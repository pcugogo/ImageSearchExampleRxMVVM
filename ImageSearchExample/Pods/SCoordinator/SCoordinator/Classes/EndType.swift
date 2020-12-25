//
//  EndType.swift
//  SCoordinator
//
//  Created by ChanWook Park on 2020/12/25.
//

import Foundation

public enum EndType {
    case dismiss(animated: Bool, completion: (() -> Void)?)
    case popView(animated: Bool)
}
