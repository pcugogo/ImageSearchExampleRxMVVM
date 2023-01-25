//
//  SearchViewModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Combine
import SCoordinator

final class SearchViewModel: ViewModelType {
    struct Input {
        let searchWithKeyword = PassthroughSubject<String, Never>()
        let willDisplayCellIndexPath = PassthroughSubject<IndexPath, Never>()
        let selectedItemIndexPath = PassthroughSubject<IndexPath, Never>()
    }
    struct Output {
        let imageDatas: CurrentValueSubject<[ImageData], Never>
        let networkError: PassthroughSubject<NetworkError, Never>
    }
    
    public let input: Input = .init()
    public let output: Output
    
    private var cancellables: CancellableSet = []
    
    init(coordinator: CoordinatorType, searchUseCase: SearchUseCaseType) {
        let imageDatasRelay = CurrentValueSubject<[ImageData], Never>([])
        let errorRelay = PassthroughSubject<NetworkError, Never>()
        let pageRelay = CurrentValueSubject<Int, Never>(1)
        let metaRelay = CurrentValueSubject<Meta?, Never>(nil)
        
        input.searchWithKeyword
            .map { (keyword) -> AnyPublisher<SearchResponse, Never> in
                return searchUseCase.search(keyword: keyword, page: 1)
                    .handleError { error in
                        guard let error = error else { return }
                        errorRelay.send(error)
                    }
            }
            .switchToLatest()
            .sink(receiveValue: { response in
                pageRelay.send(1)
                imageDatasRelay.send(response.images)
            })
            .store(in: &cancellables)
        
        input.willDisplayCellIndexPath
            .combineLatest(imageDatasRelay, pageRelay, metaRelay)
            .compactMap { indexPath, imageDatas, page, meta -> Int? in
                guard imageDatas.count - 1 == indexPath.item else { return nil }
                let isLastPage = page >= 50 && meta?.isEnd == true
                return isLastPage ? page : nil
            }
            .combineLatest(input.searchWithKeyword)
            .map { page, keyword -> AnyPublisher<SearchResponse, Never> in
                return searchUseCase.search(keyword: keyword, page: page)
                    .handleError(receiveError: {
                        errorRelay.send($0 ?? NetworkError.unknown)
                    })
            }
            .switchToLatest()
            .sink(receiveValue: {
                pageRelay.send(pageRelay.value + 1)
                imageDatasRelay.send(imageDatasRelay.value + $0.images)
            })
            .store(in: &cancellables)

        input.selectedItemIndexPath
            .combineLatest(imageDatasRelay)
            .sink(receiveValue: { indexPath, imageDatas in
                let imageURLString = imageDatas[indexPath.item].imageURL
                coordinator.navigate(to: SearchRoute.detailImage(imageURLString: imageURLString))
            })
            .store(in: &cancellables)

        output = Output(
            imageDatas: imageDatasRelay,
            networkError: errorRelay
        )
    }
}
