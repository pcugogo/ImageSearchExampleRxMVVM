//
//  ViewControllerBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/24.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

protocol ViewControllerBuilder {
    func build(_ dependency: Container) -> Container
}
