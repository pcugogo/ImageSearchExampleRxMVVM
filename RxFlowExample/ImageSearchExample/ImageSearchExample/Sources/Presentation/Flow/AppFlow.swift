//
//  AppFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/09.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

final class AppFlow: Flow {
    
    var root: Presentable {
        return self.window
    }
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func navigate(to step: Step) -> FlowContributors {
        let flow = ImageSearchFlow()
        
        Flows.use(flow, when: .created) { [weak self] root in
            self?.window.rootViewController = root
            self?.window.makeKeyAndVisible()
        }
        
        let contribute: FlowContributor = .contribute(
            withNextPresentable: flow,
            withNextStepper: OneStepper(withSingleStep: ImageSearchStep.search)
        )
        return .one(flowContributor: contribute)
    }
}
