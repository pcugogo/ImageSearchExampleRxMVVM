//
//  ViewModelType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/28.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
