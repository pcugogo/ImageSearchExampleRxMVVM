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

final class SearchViewModel: ViewModel {
    
    struct Dependency {
        let searchUseCase: SearchUseCaseType
    }
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
    
    init(coordinator: CoordinatorType, dependency: Dependency) {
        
        let isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let imagesCellItems: BehaviorRelay<[ImageData]> = .init(value: [])
        let dependency: BehaviorRelay<Dependency> = .init(value: dependency)
        let networkError: PublishRelay<NetworkError> = .init()
        
        let searchResponse = input.searchButtonAction
            .asObservable()
            .withLatestFrom(dependency, resultSelector: { ($0, $1.searchUseCase) })
            .flatMapLatest { (keyword, searchUseCase) -> Observable<SearchResponse> in
                return searchUseCase.searchImage(keyword: keyword)
                    .catchError {
                        networkError.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                }
        }
        .share()
        
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
        
        let loadMoreResponse = shouldMoreFetch
            .withLatestFrom(dependency, resultSelector: { ($0, $1.searchUseCase) })
            .filter { $0.0 }
            .map { $0.1 }
            .flatMapLatest { searchUseCase -> Observable<SearchResponse> in
                return searchUseCase.loadMoreImage()
                    .catchError {
                        networkError.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                }
        }
        .share()
        
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
        
        let imagesSections = imagesCellItems.map { [ImagesSection(model: Void(), items: $0)] }
            .asDriver(onErrorDriveWith: .empty())
        
        let seletedItemImageURL = input.itemSeletedAction.withLatestFrom(
            imagesSections,
            resultSelector: { ($0, $1) }
        )
            .map { $1[0].items[$0.item].imageURL }
            .asObservable()
        
        seletedItemImageURL
            .subscribe(onNext: { [weak coordinator] imageURLString in
                coordinator?.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        output = Output(
            imagesSections: imagesSections,
            networkError: networkError.asSignal()
        )
    }
}
