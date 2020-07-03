//
//  Extensions.swift
//  ImageSearchExample
//
//  Created by ChanWookPark on 2020/05/22.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }
}
