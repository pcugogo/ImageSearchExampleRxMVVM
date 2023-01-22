//
//  Publisher+handleError.swift
//  ImageSearchExample
//
//  Created by Park Chanwook on 2023/01/22.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import Combine

extension Publisher where Failure == NetworkError {
    func handleError(receiveError: ((NetworkError?) -> Void)?) -> AnyPublisher<Output, Never> {
        return self.handleEvents(receiveCompletion: { completion in
            guard case .failure(let error) = completion else {
                receiveError?(nil)
                return
            }
            receiveError?(error)
        })
        .catch { _ in return Empty(completeImmediately: true) }
        .eraseToAnyPublisher()
    }
}
