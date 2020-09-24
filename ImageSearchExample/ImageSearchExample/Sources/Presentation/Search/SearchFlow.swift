//
//  SearchFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/24.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchFlow: ViewControllerFlow {
    
    enum Target {
        case detailImage(imageURLString: String)
        
        var dependency: Container {
            var newDependency = Container()
            switch self {
            case .detailImage(let imageURLString):
                newDependency.regist(type: String.self, name: "imageURLString") { _ in imageURLString }
                newDependency = DetailImageBuilder().build(newDependency)
            }
            return newDependency
        }
    }
    
    init(target: Target) {
        super.init(dependency: target.dependency)
    }
}
