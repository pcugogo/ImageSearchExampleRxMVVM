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
    
    private var disposeBag: DisposeBag = .init()
    
    init(coordinator: CoordinatorType, searchUseCase: SearchUseCaseType) {
        let imagesCellItemsRelay: BehaviorRelay<[ImageData]> = .init(value: [])
        let networkErrorRelay: PublishRelay<NetworkError> = .init()
        let pageRelay: BehaviorRelay<Int> = .init(value: 1)
        let metaRelay: BehaviorRelay<Meta?> = .init(value: nil)
        let keywordRelay: BehaviorRelay<String?> = .init(value: nil)
        
        input.searchButtonAction
            .flatMapLatest { (keyword) -> Observable<(searchResponse: SearchResponse, keyword: String)> in
                return searchUseCase.search(keyword: keyword, page: 1)
                    .catch {
                        networkErrorRelay.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                    }
                    .map { (searchResponse: $0, keyword: keyword) }
            }
            .subscribe(onNext: {
                pageRelay.accept(1)
                keywordRelay.accept($0.keyword)
                imagesCellItemsRelay.accept($0.searchResponse.images)
            })
            .disposed(by: disposeBag)
        
        let isLastPage = Observable.combineLatest(pageRelay, metaRelay)
            .map { page, meta -> Bool in
                return page >= 50 && meta?.isEnd == true
            }
        
        input.willDisplayCell
            .withLatestFrom(imagesCellItemsRelay) { (indexPath: $0, data: $1) }
            .filter { $0.data.count - 1 == $0.indexPath.item }
            .withLatestFrom(isLastPage)
            .compactMap { isLastPage -> (keyword: String, page: Int)? in
                guard !isLastPage else { return nil }
                guard let keyword = keywordRelay.value else { return nil }
                return (keyword: keyword, page: pageRelay.value)
            }
            .flatMapLatest { (keyword, page) -> Observable<SearchResponse> in
                return searchUseCase.search(keyword: keyword, page: page)
                    .catch {
                        networkErrorRelay.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                    }
            }
            .subscribe(onNext: {
                pageRelay.accept(pageRelay.value + 1)
                imagesCellItemsRelay.accept(imagesCellItemsRelay.value + $0.images)
            })
            .disposed(by: disposeBag)
        
        let imagesSections = imagesCellItemsRelay.map { [ImagesSection(model: Void(), items: $0)] }
            .asDriver(onErrorDriveWith: .empty())
        
        input.itemSeletedAction
            .withLatestFrom(imagesSections, resultSelector: { (indexPath: $0, sections: $1) })
            .map { $0.sections[0].items[$0.indexPath.item].imageURL }
            .subscribe(onNext: { imageURLString in
                coordinator.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        output = Output(
            imagesSections: imagesSections,
            networkError: networkErrorRelay.asSignal()
        )
    }
}
