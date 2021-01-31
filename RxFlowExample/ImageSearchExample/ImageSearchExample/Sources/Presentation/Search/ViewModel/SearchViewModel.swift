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
import RxFlow

typealias ImagesSection = SectionModel<Void, ImageData>

final class SearchViewModel: ViewModel<SearchViewModel.Dependency>, Stepper {
    
    struct Dependency: DependencyType {
        let searchUseCase: SearchUseCaseType
    }
    struct Input {
        let searchAction: Signal<String>
        let willDisplayCell: Signal<IndexPath>
        let itemSeletedAction: Signal<IndexPath>
    }
    struct Output {
        let imagesSections: Driver<[ImagesSection]>
        let networkError: Signal<NetworkError>
    }
    
    var steps: PublishRelay<Step> = .init()
    private var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let imagesCellItems: BehaviorRelay<[ImageData]> = .init(value: [])
        let networkError: PublishRelay<NetworkError> = .init()
        
        let searchResponse = input.searchAction
            .asObservable()
            .withLatestFrom(dependency, resultSelector: { ($0, $1.searchUseCase) })
            .flatMapLatest { (keyword, searchUseCase) -> Observable<SearchResponse> in
                return searchUseCase.search(keyword: keyword)
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
        
        let shouldMoreFetch = isLastCell
            .withLatestFrom(isLastPage, resultSelector: { (isLastCell: $0, isLastPage: $1) })
            .map { $0.isLastCell && !$0.isLastPage }
            .filter { $0 }
        
        let loadMoreResponse = shouldMoreFetch
            .withLatestFrom(dependency)
            .flatMapLatest { dependency -> Observable<SearchResponse> in
                return dependency.searchUseCase.loadMoreImages()
                    .catchError {
                        networkError.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                }
        }
        .share()
        
        loadMoreResponse
            .map { $0.images }
            .withLatestFrom(imagesCellItems) { (new: $0, previous: $1) }
            .map { $0.previous + $0.new }
            .bind(to: imagesCellItems)
            .disposed(by: disposeBag)
        
        Observable.merge(searchResponse, loadMoreResponse)
            .withLatestFrom(dependency, resultSelector: { ($0, $1) })
            .map { $0.meta.isEnd || $1.searchUseCase.isLastPage }
            .bind(to: isLastPage)
            .disposed(by: disposeBag)
        
        let imagesSections = imagesCellItems.map { [ImagesSection(model: Void(), items: $0)] }
            
        let seletedItemImageURL = input.itemSeletedAction
            .asObservable()
            .withLatestFrom(
                imagesSections,
                resultSelector: { (indexPath: $0, sections: $1) }
            )
            .map { $0.sections[0].items[$0.indexPath.item].imageURL }
        
        seletedItemImageURL
            .subscribe(onNext: { [weak self] imageURLString in
                guard let self = self else { return }
                self.steps.accept(ImageSearchStep.detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        return Output(
            imagesSections: imagesSections.asDriver(onErrorDriveWith: .empty()),
            networkError: networkError.asSignal()
        )
    }
}
