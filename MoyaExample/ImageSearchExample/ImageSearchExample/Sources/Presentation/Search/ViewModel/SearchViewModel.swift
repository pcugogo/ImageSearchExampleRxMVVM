//
//  SearchViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import RxDataSources
import SCoordinator

typealias ImagesSection = SectionModel<Void, ImageData>

final class SearchViewModel: ViewModelType {
    
    struct Input {
        let searchButtonAction: PublishRelay<String> = .init()
        let willDisplayCell: PublishRelay<IndexPath> = .init()
        let itemSeletedAction: PublishRelay<IndexPath> = .init()
    }
    struct Output {
        let imagesSections: Driver<[ImagesSection]>
        let networkError: Signal<NetworkError>
    }
    
    public let input: Input = .init()
    public let output: Output
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(coordinator: CoordinatorType, searchUseCase: SearchUseCaseType) {
        
        let isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let imagesCellItems: BehaviorRelay<[ImageData]> = .init(value: [])
        let networkError: PublishRelay<NetworkError> = .init()
        
        let searchResult = input.searchButtonAction
            .flatMapLatest { searchUseCase.search(keyword: $0) }
            .share()
        
        let searchResponse = searchResult.map { $0.response() }
            .filterNil()
        
        searchResponse
            .map { $0.images }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        let isLastCell = input.willDisplayCell
            .withLatestFrom(imagesCellItems) { (indexPath: $0, data: $1) }
            .map { $0.data.count - 1 == $0.indexPath.item }
            .filter { $0 }
        
        let shouldMoreFetch = isLastCell
            .withLatestFrom(isLastPage, resultSelector: { (isLastCell: $0, isLastPage: $1) })
            .map { $0.isLastCell && !$0.isLastPage }
            .filter { $0 }
        
        let loadMoreResult = shouldMoreFetch
            .flatMapLatest { _ in searchUseCase.loadMoreImages() }
            .share()
        
        let loadMoreResponse = loadMoreResult.map { $0.response() }
            .filterNil()
        
        loadMoreResponse
            .map { $0.images }
            .withLatestFrom(imagesCellItems) { (new: $0, previous: $1) }
            .map { $0.previous + $0.new }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        Observable.merge(searchResponse, loadMoreResponse)
            .map { $0.meta.isEnd || searchUseCase.isLastPage }
            .bind(to: isLastPage)
            .disposed(by: disposeBag)
        
        let imagesSections = imagesCellItems.map { [ImagesSection(model: Void(), items: $0)] }
            .asDriver(onErrorDriveWith: .empty())
        
        let seletedItemImageURL = input.itemSeletedAction.withLatestFrom(
            imagesSections,
            resultSelector: { (indexPath: $0, sections: $1) }
        )
        .map { $0.sections[0].items[$0.indexPath.item].imageURL }
        
        seletedItemImageURL
            .subscribe(onNext: { [weak coordinator] imageURLString in
                coordinator?.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        Observable.merge(searchResult, loadMoreResult)
            .map { $0.error() }
            .filterNil()
            .bind(to: networkError)
            .disposed(by: disposeBag)
        
        output = Output(
            imagesSections: imagesSections,
            networkError: networkError.asSignal()
        )
    }
}
