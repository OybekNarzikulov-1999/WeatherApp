//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit

protocol Coordinator: AnyObject {
	var childCoordinators: [Coordinator] {get}
	var navigationController: UINavigationController {get}
	
	func start()
	func childDidFinish(childCoordinator: Coordinator)
}

extension Coordinator {
	func childDidFinish(childCoordinator: Coordinator) {}
}

final class AppCoordinator: Coordinator {
	
	private(set) var childCoordinators: [Coordinator] = []
	private(set) var navigationController: UINavigationController
	
	private var window: UIWindow
	
	init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
		self.window = window
		self.navigationController = navigationController
	}
	
	func start() {
		let mainCoordinator = MainCoordinator(navigationController: navigationController)
		mainCoordinator.start()
		childCoordinators.append(mainCoordinator)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}
	
}
