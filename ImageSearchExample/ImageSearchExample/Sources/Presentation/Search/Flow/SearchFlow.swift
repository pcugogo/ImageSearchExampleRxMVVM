//
//  SearchFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct SearchFlow: ViewControllerFlow {
    enum Target {
        case detailImage(imageURLString: String)
    }
    
    let target: Target
    
    var viewController: UIViewController {
        switch target {
        case .detailImage(let imageURLString):
            return detailImageViewController(imageURLString: imageURLString)
        }
    }
    
    init(target: Target) {
        self.target = target
    }
    
    private func detailImageViewController(imageURLString: String) -> UIViewController {
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
