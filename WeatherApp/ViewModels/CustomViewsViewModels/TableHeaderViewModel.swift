//
//  TableHeaderViewModel.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 31/05/23.
//

import Foundation


final class TableHeaderViewModel {
	
	private var hourlyWeather: HourlyWeather
	
	var weatherString: String {
		guard let weatherCode = hourlyWeather.weatherCode.first else {return ""}
		if weatherCode < 4 {
			return "sun"
		} else if weatherCode < 68 {
			return "drizzle"
		} else if weatherCode < 87 {
			return "snow"
		} else {
			return "storm"
		}
	}
	
	var temperature: String {
		return "\(Int(hourlyWeather.temperature.first ?? 0))°"
	}
	
	init(hourlyWeather: HourlyWeather) {
		self.hourlyWeather = hourlyWeather
	}
}
