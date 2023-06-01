//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator, AnyObject {
	func onSelect(_ index: IndexPath)
	func childDidFinish(childCoordinator: Coordinator)
}


final class MainCoordinator: MainCoordinatorProtocol {
	
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let mainViewController = MainViewController()
		let mainViewModel = MainViewModel(coordinator: self)
		mainViewController.viewModel = mainViewModel
		navigationController.setViewControllers([mainViewController], animated: false)
	}
	
	func onSelect(_ index: IndexPath){
		let detailCoordinator = DetailCoordinator(navigationController: navigationController, index: index, parentCoordinator: self)
		childCoordinators.append(detailCoordinator)
		detailCoordinator.start()
	}
	
	func childDidFinish(childCoordinator: Coordinator) {
		
		if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
			return childCoordinator === coordinator
		}) {
			childCoordinators.remove(at: index)
		}
	}
	
}
