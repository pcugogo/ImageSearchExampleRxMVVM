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
        let imageDatas: Driver<[ImageData]>
        let networkError: Signal<NetworkError>
    }
    
    public let input: Input = .init()
    public let output: Output
    
    private var disposeBag: DisposeBag = .init()
    
    init(coordinator: CoordinatorType, searchUseCase: SearchUseCaseType) {
        let imageDatasRelay: BehaviorRelay<[ImageData]> = .init(value: [])
        let errorRelay: PublishRelay<NetworkError> = .init()
        let pageRelay: BehaviorRelay<Int> = .init(value: 0)
        let metaRelay: BehaviorRelay<Meta?> = .init(value: nil)
        let currentKeyword = BehaviorRelay<String>(value: "")
        
        let isLastPage = Observable.combineLatest(pageRelay, metaRelay)
            .map { $0 >= 50 && $1?.isEnd == true }
        
        let reachedThreshold = input.willDisplayCellIndexPath
            .withLatestFrom(imageDatasRelay) { (indexPath: $0, data: $1) }
            .filter { $0.data.count - 1 <= $0.indexPath.item }
        
        let loadMore = reachedThreshold
            .withLatestFrom(isLastPage)
            .filter { $0 == false }
            .withLatestFrom(currentKeyword)
        
        Observable.merge(input.searchWithKeyword.asObservable(), loadMore)
            .flatMapLatest { (keyword) -> Observable<(response: SearchResponse, keyword: String)> in
                return searchUseCase.search(keyword: keyword, page: 1)
                    .catch {
                        errorRelay.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                    }
                    .map { (response: $0, keyword: keyword) }
            }
            .withLatestFrom(pageRelay, resultSelector: { ($0.response, $0.keyword, $1) })
            .subscribe(onNext: { response, keyword, page in
                let isFirstSearch = page == 0
                
                if isFirstSearch {
                    currentKeyword.accept(keyword)
                }
                
                pageRelay.accept(isFirstSearch ? 1 : page + 1)
                
                let newImageDatas = isFirstSearch ? response.imageDatas : (imageDatasRelay.value + response.imageDatas)
                imageDatasRelay.accept(newImageDatas)
            })
            .disposed(by: disposeBag)
        
        input.selectedItemIndexPath
            .withLatestFrom(imageDatasRelay, resultSelector: { (indexPath: $0, datas: $1) })
            .map { $0.datas[$0.indexPath.item].imageURL }
            .subscribe(onNext: { imageURLString in
                coordinator.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            })
            .disposed(by: disposeBag)
        
        output = Output(
            imageDatas: imageDatasRelay.asDriver(),
            networkError: errorRelay.asSignal()
        )
    }
}
