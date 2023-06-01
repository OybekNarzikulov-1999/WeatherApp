//
//  DetailCoordinator.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit


protocol DetailCoordinatorProtocol: Coordinator {
	func didFinish()
}


final class DetailCoordinator: DetailCoordinatorProtocol {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	weak var parentCoordinator: MainCoordinatorProtocol?
	var indexPath: IndexPath
	
	init(navigationController: UINavigationController, index: IndexPath, parentCoordinator: MainCoordinatorProtocol) {
		self.navigationController = navigationController
		self.parentCoordinator = parentCoordinator
		self.indexPath = index
	}
	
	func start() {
		let detailViewController = DetailViewController()
		let detailViewModel = DetailViewModel(indexPath: indexPath, coordinator: self)
		detailViewController.viewModel = detailViewModel
		navigationController.pushViewController(detailViewController, animated: true)
	}
	
	func didFinish() {
		parentCoordinator?.childDidFinish(childCoordinator: self)
	}
	
}
