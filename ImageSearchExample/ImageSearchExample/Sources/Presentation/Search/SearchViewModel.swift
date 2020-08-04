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
    var searchButtonAction: PublishRelay<String> { get }
    var willDisplayCell: PublishRelay<IndexPath> { get }
}

protocol SearchViewModelTypeOutputs {
    var imagesCellItems: Driver<[Image]> { get }
    var errorMessage: Signal<String> { get }
}

protocol SearchViewModelType: SearchViewModelTypeInputs, SearchViewModelTypeOutputs {
    var inputs: SearchViewModelTypeInputs { get }
    var outputs: SearchViewModelTypeOutputs { get }
}

final class SearchViewModel: SearchViewModelType {
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Input Sources
    var inputs: SearchViewModelTypeInputs { return self }
    let searchButtonAction: PublishRelay<String> = .init()
    let willDisplayCell: PublishRelay<IndexPath> = .init()
    
    // MARK: - Output Sources
    var outputs: SearchViewModelTypeOutputs { return self }
    let imagesCellItems: Driver<[Image]>
    let errorMessage: Signal<String>
    
    init(model: SearchModelType = SearchModel(apiService: APIService())) {
        let isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let imagesCellItems: BehaviorRelay<[Image]> = .init(value: [])
        
        //새로운 검색
        let newSearch = searchButtonAction
            .flatMapLatest { model.searchImage(keyword: $0, isNextPage: false) }
            .asObservable()
            .share()

        //검색 응답 데이터
        let searchResponse = newSearch
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else { return nil }
                return response
        }
        .filterNil()
        
        //셀 데이터 저장
        searchResponse
            .map { $0.images }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        //마지막 셀인지 여부
        let isLastCell = willDisplayCell
            .withLatestFrom(imagesCellItems) { (indexPath: $0, data: $1) }
            .map { $0.data.count - 1 == $0.indexPath.item }
            .filter { $0 }
        
        //데이터가 더 필요한지 여부
        let shouldMoreFetch = isLastCell.withLatestFrom(isLastPage,
                                                        resultSelector: { ($0, $1) })
            .map { $0.0 && !$0.1 }
        
        //추가 데이터 요청
        let loadMore = shouldMoreFetch.withLatestFrom(searchButtonAction,
                                                      resultSelector: { ($0, $1) })
            .filter { $0.0 }
            .map { $1 }
            .flatMapLatest { model.searchImage(keyword: $0, isNextPage: true) }
            .share()
        
        //추가로 요청한 응답 데이터
        let loadMoreResponse = loadMore
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else {
                    return nil
                }
                return response
        }
        .filterNil()
        
        //기존 데이터에 새로운 데이터를 추가
        loadMoreResponse
            .map { $0.images }
            .withLatestFrom(imagesCellItems) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        //응답데이터가 마지막 페이지인지 여부
        Observable.merge(searchResponse, loadMoreResponse)
            .map { $0.meta.isEnd }
            .bind(to: isLastPage)
            .disposed(by: disposeBag)
        
        //에러 메시지 저장
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
        self.imagesCellItems = imagesCellItems.asDriver(onErrorDriveWith: .empty())
    }
}
