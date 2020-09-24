//
//  DetailImageBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/24.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct DetailImageBuilder: ViewControllerBuilder {
    func build(_ dependency: Container) -> Container {
        dependency.regist(type: ImageFavoritesStorageType.self) { _ in ImageFavoritesStorage() }
        dependency.regist(type: DetailImageViewModelType.self) {
            DetailImageViewModel(imageFavoritesStorage: $0.resolve(type: ImageFavoritesStorageType.self)!,
                                 imageURLString: $0.resolve(type: String.self, name: "imageURLString")!)
        }
        dependency.regist(type: UIViewController.self) { _ in
            let storyboard = StoryboardName.main.instantiateStoryboard()
            var detailImageViewController = storyboard.instantiateViewController(withIdentifier:
                String(describing: DetailImageViewController.self)) as! DetailImageViewController
            detailImageViewController.bind(viewModel: dependency.resolve(type: DetailImageViewModelType.self)!)
            return detailImageViewController
        }
        return dependency
    }
}
