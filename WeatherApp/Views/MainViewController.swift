//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
	
	var viewModel: MainViewModelProtocol?
	
	var locationManager: CLLocationManager!
	var alertController = UIAlertController()

	private let tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		return tableView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(tableView)

		viewModel?.showNoInternetLabel = { [weak self] in
			self?.alertController.doesInternetWork(status: "OFF", style: .cancel)
		}
		
		viewModel?.showError = { [weak self] errorString in
			self?.alertController.showError(errorString: errorString)
		}
		
		viewModel?.updateTable = { [weak self] in
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
		
		setupTableView()
		setupNavigationBar()
		
		locationManager = CLLocationManager()
		locationManager.delegate = self
	}
	
	
	func setupNavigationBar() {
		navigationItem.title = "Weather"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
		navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
		
	}
    
	func setupTableView() {
		tableView.backgroundColor = .white
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		tableView.showsVerticalScrollIndicator = false
		tableView.frame = view.bounds
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
		tableView.register(TableViewSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewSectionHeaderView")
		let view = TableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
		viewModel?.updateTableHeader = { hourlyWeatherData in
			DispatchQueue.main.async {
				view.update(hourlyWeatherData)
			}
		}
		tableView.tableHeaderView = view
		tableView.setContentOffset(CGPoint(x: 0, y: -1), animated: false)
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
	}
	
	@objc private func didPullToRefresh() {
		locationManager.startUpdatingLocation()
		DispatchQueue.main.async {
			self.tableView.refreshControl?.endRefreshing()
		}
	}
	
}

extension MainViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.cellCount ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell,
			  let currentViewModel = viewModel?.cell(at: indexPath) else {return UITableViewCell()}
		cell.update(currentViewModel)
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		35
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewSectionHeaderView") as? TableViewSectionHeaderView else {return UIView()}
		view.filterDays = {[weak self] day in
			view.title.text = self?.viewModel?.filterDays(day)
		}
		return view
	}
}

extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		viewModel?.didSelectRow(at: indexPath)
	}
}


extension MainViewController: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .restricted, .denied:
			return
		case .authorizedAlways:
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		case .authorizedWhenInUse:
			locationManager.startUpdatingLocation()
			locationManager.requestAlwaysAuthorization()
		@unknown default:
			return
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		viewModel?.currentLocation = locations.first
		manager.stopUpdatingLocation()
	}
	
}
