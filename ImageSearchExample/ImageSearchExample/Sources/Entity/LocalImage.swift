//
//  LocalImage.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 07/06/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct LocalImage {
    let imageURL: String
    let addedFavorite: Bool

    init(url: String, addedFavorite: Bool) {
        imageURL = url
        self.addedFavorite = addedFavorite
    }
}
