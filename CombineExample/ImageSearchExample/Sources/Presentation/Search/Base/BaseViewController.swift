//
//  BaseViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/28.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Combine
import RxSwift

class BaseViewController: UIViewController {
    var cancellables: CancellableSet = []
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
