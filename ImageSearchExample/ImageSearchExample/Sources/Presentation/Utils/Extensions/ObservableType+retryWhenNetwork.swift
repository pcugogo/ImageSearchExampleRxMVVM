//
//  ObservableType+retryWhenNetwork.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/02.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift

extension ObservableType {
    func retryWhenNetwork(
        maxRetry: Int = 1,
        timeInterval: RxTimeInterval = .seconds(2),
        scheduler: SchedulerType = MainScheduler.instance
    ) -> Observable<Element> {
        return self.retryWhen { errorObservable -> Observable<Void> in
            return Observable.zip(
                errorObservable.map { $0 as? NetworkError ?? NetworkError.unknown }
                    .map { error -> NetworkError in
                        switch error {
                        case NetworkError.serverError:
                            return error
                        default:
                            throw error
                        }
                },
                Observable<Int>.interval(timeInterval, scheduler: scheduler),
                resultSelector: { error, retryCount in
                    guard retryCount < maxRetry else { return Void() }
                    throw error
                }
            )
        }
    }
}
