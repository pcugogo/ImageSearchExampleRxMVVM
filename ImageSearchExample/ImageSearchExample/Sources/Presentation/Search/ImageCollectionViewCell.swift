//
//  ImageCollectionViewCell.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 03/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import Kingfisher

final class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(urlString: String) {
        DispatchQueue.global().async {
            if let imageURL = URL(string: urlString) {
                DispatchQueue.main.async {[weak self] in
                    guard let self = self else { return }
                    self.imageView.kf.setImage(with: imageURL)
                }
            }
        }
    }
}
