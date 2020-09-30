//
//  DetailImageCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class DetailImageCoordinator: Coordinator {
    
    struct Dependency {
        let imageURLString: String
        let imageFavoritesStorage: ImageFavoritesStorageType
        
        init(imageURLString: String, imageFavoritesStorage: ImageFavoritesStorageType) {
            self.imageURLString = imageURLString
            self.imageFavoritesStorage = imageFavoritesStorage
        }
    }
    
    enum Route {}
    
    func present(for route: Route) {}
}
