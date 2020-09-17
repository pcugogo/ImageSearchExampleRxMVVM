//
//  SearchBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchBuilder: ViewControllerBuilder {
    enum Target {
        case detailImage(imageURLString: String)
    }
    
    init(target: Target, dependency: Container = Container()) {
        super.init(dependency: dependency)
        switch target {
        case .detailImage:
            dependency.regist(type: ImageFavoritesStorageType.self) { _ in ImageFavoritesStorage() }
            dependency.regist(type: DetailImageViewModelType.self) {
                DetailImageViewModel(imageFavoritesStorage: $0.resolve(type: ImageFavoritesStorageType.self)!,
                                     imageURLString: $0.resolve(type: String.self, name: "imageURLString")!)
            }
            dependency.regist(type: UIViewController.self) { _ in
                let storyboard = StoryboardName.main.instantiateStoryboard()
                guard var detailImageViewController = storyboard.instantiateViewController(withIdentifier:
                    String(describing: DetailImageViewController.self)) as? DetailImageViewController
                    else { fatalError() }
                detailImageViewController.bind(viewModel: dependency.resolve(type: DetailImageViewModelType.self)!)
                return detailImageViewController
            }
        }
        self.dependency = dependency
    }
}
