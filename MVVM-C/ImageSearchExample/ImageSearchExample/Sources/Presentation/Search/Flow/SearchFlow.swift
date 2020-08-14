//
//  SearchFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchFlow: ViewConrollerFlowType {
    enum Flow {
        case detailImage(imageURLString: String)
    }
    
    private var flow: Flow
    
    var viewController: UIViewController {
        switch flow {
        case .detailImage(let imageURLString):
            return detailImageViewController(imageURLString: imageURLString)
        }
    }
    
    init(flow: Flow) {
        self.flow = flow
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
