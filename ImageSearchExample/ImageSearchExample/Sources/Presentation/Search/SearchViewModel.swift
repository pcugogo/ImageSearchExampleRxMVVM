//
//  SearchViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

protocol SearchViewModelTypeInputs {
    var searchButtonAction: PublishSubject<String> { get }
    var willDisplayCell: PublishRelay<IndexPath> { get }
}

protocol SearchViewModelTypeOutputs {
    var imagesCellItems: BehaviorRelay<[Image]> { get }
    var errorMessage: Signal<String> { get }
}

protocol SearchViewModelType {
    var inputs: SearchViewModelTypeInputs { get }
    var outputs: SearchViewModelTypeOutputs { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelTypeInputs, SearchViewModelTypeOutputs {
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Input Sources
    var inputs: SearchViewModelTypeInputs { return self }
    let searchButtonAction: PublishSubject<String> = .init()
    let willDisplayCell: PublishRelay<IndexPath> = .init()
    
    // MARK: - Output Sources
    var outputs: SearchViewModelTypeOutputs { return self }
    let imagesCellItems: BehaviorRelay<[Image]> = .init(value: [])
    let errorMessage: Signal<String>
    
    private var isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init(model: SearchModelType = SearchModel(apiService: APIService())) {
        
        let newSearch = searchButtonAction
            .flatMapLatest { model.searchImage(keyword: $0, isNextPage: false) }
            .asObservable()
            .share()
        
        let searchResponse = newSearch
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else { return nil }
                return response
        }
        .filterNil()
        
        searchResponse
            .map { $0.documents }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        let isLastCell = willDisplayCell
            .withLatestFrom(imagesCellItems) { (indexPath: $0, data: $1) }
            .map { $0.data.count - 5 == $0.indexPath.item }
        
        let shouldMoreFetch = Observable
            .combineLatest(isLastCell, isLastPage)
            .map { $0.0 && !$0.1}
        
        let loadMore = shouldMoreFetch.withLatestFrom(searchButtonAction, resultSelector: { ($0, $1) })
            .filter { $0.0 }
            .map { $1 }
            .flatMapLatest { model.searchImage(keyword: $0, isNextPage: true) }
            .share()
        
        let loadMoreResult = loadMore
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else {
                    return nil
                }
                return response
        }
        .filterNil()
        
        loadMoreResult
            .map { $0.documents }
            .withLatestFrom(imagesCellItems) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        Observable.merge(searchResponse, loadMoreResult)
            .map { $0.meta.isEnd }
            .bind(to: isLastPage)
            .disposed(by: disposeBag)
        
        let errorMessage = Observable.merge(newSearch, loadMore)
            .map { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.reason
        }
        .filterNil()
        .asSignal(onErrorSignalWith: .empty())
        
        self.errorMessage = errorMessage
    }
}
