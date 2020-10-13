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
import RxDataSources

typealias ImagesSection = SectionModel<Void, ImageData>

final class SearchViewModel: ViewModel<SearchCoordinator.Dependency> {
    
    struct Input {
        let searchButtonAction: Driver<String>
        let willDisplayCell: Driver<IndexPath>
        var itemSeletedAction: Driver<IndexPath>
    }
    struct Output {
        let imagesSections: Driver<[ImagesSection]>
        let errorMessage: Signal<String>
    }
    
    private var disposeBag: DisposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        let isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let imagesCellItems: BehaviorRelay<[ImageData]> = .init(value: [])
        let dependency: BehaviorRelay<SearchCoordinator.Dependency> = .init(value: self.dependency)
        
        let newSearch = input.searchButtonAction
            .asObservable()
            .withLatestFrom(dependency, resultSelector: { ($0, $1) })
            .flatMapLatest { $1.searchUseCase.searchImage(keyword: $0) }
            .asObservable()
            .share()

        let searchResponse = newSearch
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else { return nil }
                return response
            }
            .filterNil()
        
        searchResponse
            .map { $0.images }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        let isLastCell = input.willDisplayCell
            .asObservable()
            .withLatestFrom(imagesCellItems) { (indexPath: $0, data: $1) }
            .map { $0.data.count - 1 == $0.indexPath.item }
            .filter { $0 }
        
        let shouldMoreFetch = isLastCell.withLatestFrom(isLastPage, resultSelector: { ($0, $1) })
            .map { $0.0 && !$0.1 }
        
        let loadMore = shouldMoreFetch
            .withLatestFrom(dependency, resultSelector: { ($0, $1) })
            .filter { $0.0 }
            .flatMapLatest { $0.1.searchUseCase.loadMoreImage() }
            .share()
        
        let loadMoreResponse = loadMore
            .map { result -> SearchResponse? in
                guard case .success(let response) = result else { return nil }
                return response
            }
            .filterNil()
        
        loadMoreResponse
            .map { $0.images }
            .withLatestFrom(imagesCellItems) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        Observable.merge(searchResponse, loadMoreResponse)
            .withLatestFrom(dependency, resultSelector: { ($0, $1) })
            .map { $0.meta.isEnd || $1.searchUseCase.isLastPage }
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
        
        let imagesSections = imagesCellItems.map { [ImagesSection(model: Void(), items: $0)] }
            .asDriver(onErrorDriveWith: .empty())
        
        let seletedItemImageURL = input.itemSeletedAction.withLatestFrom(
            imagesSections,
            resultSelector: { ($0, $1) }
        )
        .map { $1[0].items[$0.item].imageURL }
        .asObservable()
        
        seletedItemImageURL.withLatestFrom(coordinator) { ($0, $1) }
            .subscribe(onNext: { (imageURLString, coordinator) in
                coordinator.navigate(to: .detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        return Output(imagesSections: imagesSections, errorMessage: errorMessage)
    }
}
