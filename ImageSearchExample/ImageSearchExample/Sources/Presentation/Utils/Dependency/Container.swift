//
//  Container.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/17.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

final class Container {
    private var registered: [String:Any] = [:]
    
    func regist<T>(type: T.Type, name: String? = nil, builder: (Container) -> T) {
        let instance = builder(self)
        let typeName = name ?? String(describing: type)
        registered[typeName] = instance
    }
    
    func resolve<T>(type: T.Type, name: String? = nil) -> T? {
        let typeName = name ?? String(describing: type)
        guard let instance = registered[typeName] else { return nil }
        return instance as? T
    }
}
