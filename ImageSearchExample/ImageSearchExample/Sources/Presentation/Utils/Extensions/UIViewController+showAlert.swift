//
//  showAlert.swift
//  ImageSearchExample
//
//  Created by ChanWookPark on 2020/05/22.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, animated: Bool = true, completion:  (() -> Void)? = nil) {
        let alertViewController = UIAlertController(
            title: title,
            message: message, preferredStyle: .alert
        )
        alertViewController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        present(alertViewController, animated: true, completion: completion)
    }
}
