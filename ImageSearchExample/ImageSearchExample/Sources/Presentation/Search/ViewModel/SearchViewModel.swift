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
        let searchWithKeyword: PublishRelay<String> = .init()
        let willDisplayCellIndexPath: PublishRelay<IndexPath> = .init()
        let selectedItemIndexPath: PublishRelay<IndexPath> = .init()
    }
    struct Output {
        let imagesSections: Driver<[ImagesSection]>
        let networkError: Signal<NetworkError>
    }
    
    public let input: Input = .init()
    public let output: Output
    
    private var disposeBag: DisposeBag = .init()
    
    init(coordinator: CoordinatorType, searchUseCase: SearchUseCaseType) {
        let imageDatasRelay: BehaviorRelay<[ImageData]> = .init(value: [])
        let errorRelay: PublishRelay<NetworkError> = .init()
        let pageRelay: BehaviorRelay<Int> = .init(value: 1)
        let metaRelay: BehaviorRelay<Meta?> = .init(value: nil)
        
        input.searchWithKeyword
            .flatMapLatest { (keyword) -> Observable<(searchResponse: SearchResponse, keyword: String)> in
                return searchUseCase.search(keyword: keyword, page: 1)
                    .catch {
                        errorRelay.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                    }
                    .map { (searchResponse: $0, keyword: keyword) }
            }
            .do(onNext: {
                pageRelay.accept(1)
            })
            .map { $0.searchResponse.images }
            .subscribe(onNext: {
                pageRelay.accept(1)
                imageDatasRelay.accept($0.searchResponse.images)
            })
            .disposed(by: disposeBag)
        
        let isLastPage = Observable.combineLatest(pageRelay, metaRelay)
            .map { $0 >= 50 && $1?.isEnd == true }
        
        let isThresholdReached = input.willDisplayCellIndexPath
            .withLatestFrom(imageDatasRelay) { (indexPath: $0, data: $1) }
            .filter { $0.data.count - 1 == $0.indexPath.item }
        
        let shouldLoadMore = isThresholdReached
            .withLatestFrom(isLastPage)
            .compactMap { $0 ? nil : Void() }
        
        shouldLoadMore
            .withLatestFrom(input.searchWithKeyword)
            .flatMapLatest { keyword -> Observable<SearchResponse> in
                return searchUseCase.search(keyword: keyword, page: pageRelay.value)
                    .catch {
                        errorRelay.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                    }
            }
            .subscribe(onNext: {
                pageRelay.accept(pageRelay.value + 1)
                imageDatasRelay.accept(imageDatasRelay.value + $0.images)
            })
            .disposed(by: disposeBag)
        
        let imagesSections = imageDatasRelay.map { [ImagesSection(model: Void(), items: $0)] }
            .asDriver(onErrorDriveWith: .empty())
        
        input.selectedItemIndexPath
            .withLatestFrom(imagesSections, resultSelector: { (indexPath: $0, sections: $1) })
            .map { $0.sections[0].items[$0.indexPath.item].imageURL }
            .subscribe(onNext: { imageURLString in
                coordinator.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        output = Output(
            imagesSections: imagesSections,
            networkError: errorRelay.asSignal()
        )
    }
}
