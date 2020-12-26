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
        if let imageURL = URL(string: urlString) {
            self.imageView.kf.setImage(with: imageURL, options: [.transition(ImageTransition.fade(0.3))])
        }
    }
}
