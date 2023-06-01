//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import Foundation
import CoreLocation

protocol MainViewModelProtocol: AnyObject {
	var cells: [MainCellViewModel] {get set}
	var currentLocation: CLLocation? {get set}
	var updateTable: (() -> ()) {get set}
	var cellCount: Int {get set}
	var updateTableHeader: ((TableHeaderViewModel) -> ())? {get set}
	var hasInternet: ((Bool) -> ())? {get set}
	var showError: ((String) -> ())? {get set}
	var showNoInternetLabel: (() -> ())? {get set}
	
	func cell(at indexPath: IndexPath) -> MainCellViewModel
	func filterDays(_ numberOfDays: NumberOfDays) -> String
	func didSelectRow(at: IndexPath)
}

final class MainViewModel: MainViewModelProtocol {
	
	private(set) var coordinator: MainCoordinatorProtocol
	private(set) var service: Service
	
	var cellCount: Int = 0
	var cells: [MainCellViewModel] = []
	var updateTable = {}
	var updateTableHeader: ((TableHeaderViewModel) -> ())?
	
	var hasInternet: ((Bool) -> ())?
	var showError: ((String) -> ())?
	var showNoInternetLabel: (() -> ())?
	
	var timezoneString: String {
		return TimeZone.current.identifier.replacingOccurrences(of: "/", with: "%2F")
	}
	var currentLocation: CLLocation? {
		didSet {
			cellCount = 7
			getForecast()
		}
	}
	
	init(coordinator: MainCoordinatorProtocol, service: Service = Service()){
		self.coordinator = coordinator
		self.service = service
	}
	
	func getForecast() {
		
		guard let lat = currentLocation?.coordinate.latitude, let lon = currentLocation?.coordinate.longitude else {return}
		let timezone = timezoneString
		
		if Reachability.isConnectedToNetwork() {
			service.getWeatherData { [weak self] result in
				switch result {
				case .success(let weatherDatabaseData):
					self?.reloadTable(weatherDatabaseData)
					self?.service.updateWeatherData(lat: lat, lon: lon, timezone: timezone) { [weak self] result in
						switch result {
						case .success(let weatherApiData):
							self?.reloadTable(weatherApiData)
						case .failure(_):
							self?.showError?("API CALL ERROR")
						}
					}
				case .failure(_):
					self?.service.updateWeatherData(lat: lat, lon: lon, timezone: timezone) { [weak self] result in
						switch result {
						case .success(let weatherApiData):
							self?.reloadTable(weatherApiData)
						case .failure(_):
							self?.showError?("API CALL ERROR")
						}
					}
				}
			}
			
		} else {
			service.getWeatherData { [weak self] result in
				switch result {
				case .success(let weatherDatabaseData):
					self?.reloadTable(weatherDatabaseData)
				case .failure(_):
					self?.showNoInternetLabel?()
				}
			}
		}
	}
	
	func reloadTable(_ weatherData: WeatherResponse) {
		cells.removeAll()
		for i in 0 ..< weatherData.daily.time.count {
			let mainCellViewModel = MainCellViewModel(time: weatherData.daily.time[i], weatherCode: weatherData.daily.weatherCode[i], maxTemp: weatherData.daily.maxTemperature[i], minTemp: weatherData.daily.minTemperature[i])
			cells.append(mainCellViewModel)
		}
		
		updateTableHeader?(TableHeaderViewModel(hourlyWeather: weatherData.hourly))
		
		updateTable()
	}
	
	func cell(at indexPath: IndexPath) -> MainCellViewModel {
		return cells[indexPath.row]
	}
	
	func didSelectRow(at index: IndexPath) {
		coordinator.onSelect(index)
	}
	
	func filterDays(_ numberOfDays: NumberOfDays) -> String {
		switch numberOfDays {
		case .three:
			self.cellCount = 3
			updateTable()
			return "Weather for 3 days"
		case .five:
			self.cellCount = 5
			updateTable()
			return "Weather for 5 days"
		case .seven:
			self.cellCount = 7
			updateTable()
			return "Weather for 7 days"
		}
	}
	
}
