//
//  DetailViewModel.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import Foundation

protocol DetailViewModelProtocol {
	var updateCollection: (() -> ()) {get set}
	var date: String? {get set}
	
	func fetchHourlyWeather()
	func cell(at indexPath: IndexPath) -> DetailCellViewModel
	func viewDidDisappear()
}

final class DetailViewModel: DetailViewModelProtocol {
	var coordinator: DetailCoordinatorProtocol
	private(set) var service: Service
	var indexPath: IndexPath
	
	var cells: [DetailCellViewModel] = []
	
	var updateCollection = {}
	
	private var dateFormatter: String {
		let formatter = DateFormatter()
		return formatter.weekdaySymbols[(Calendar.current.component(.weekday, from: Date()) - 1 + indexPath.row) % 7]
	}
	
	var date: String?
	
	init(indexPath: IndexPath, coordinator: DetailCoordinatorProtocol, service: Service = Service()) {
		self.coordinator = coordinator
		self.indexPath = indexPath
		self.service = service
	}
	
	func fetchHourlyWeather(){
		date = dateFormatter
		service.getWeatherData { [weak self] result in
			switch result {
			case .success(let weatherResponse):
				self?.reloadCollection(weatherResponse.hourly)
			case .failure(_):
				print("Error")
			}
		}
	}
	
	func reloadCollection(_ hourlyWeather: HourlyWeather) {
		cells.removeAll()
		
		let rangeEnd = (indexPath.row + 1) * 24
		let rangeStart = rangeEnd - 24
		
		var timeArray: [String] = []
		var tempArray: [Float] = []
		
		for time in 0 ..< 168 {
			if time >= rangeStart && time < rangeEnd {
				tempArray.append(hourlyWeather.temperature[time])
				timeArray.append(hourlyWeather.time[time])
			}
		}
		
		for i in 0 ..< 24 {
			let detailCellViewModel = DetailCellViewModel(time: timeArray[i], temperature: tempArray[i])
			cells.append(detailCellViewModel)
		}
		
		updateCollection()
	}
	
	func cell(at indexPath: IndexPath) -> DetailCellViewModel {
		return cells[indexPath.row]
	}
	
	func viewDidDisappear() {
		coordinator.didFinish()
	}
	
}
