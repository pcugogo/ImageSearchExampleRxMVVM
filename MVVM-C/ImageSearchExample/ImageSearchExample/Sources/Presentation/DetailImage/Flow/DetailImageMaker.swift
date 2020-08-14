//
//  DetailImageMaker.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 14/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct DetailImageMaker: ViewControllerMaker {
    let imageURLString: String
    
    init(imageURLString: String) {
        self.imageURLString = imageURLString
    }
    
    func makeViewController() -> UIViewController {
        let storyboard = StoryboardName.main.instantiateStoryboard()
        guard var detailImageViewController = storyboard.instantiateViewController(withIdentifier:
            String(describing: DetailImageViewController.self)) as? DetailImageViewController
            else { fatalError() }
        let viewModel = DetailImageViewModel(imageFavoritesStorage: ImageFavoritesStorage(),
                                             imageURLString: imageURLString)
        detailImageViewController.bind(viewModel: viewModel)
        return detailImageViewController
    }
}
