//
//  MainCellViewModel.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 31/05/23.
//

import Foundation


final class MainCellViewModel {
	private var time: String
	private var weatherCode: Int
	private var maxTemp: Float
	private var minTemp: Float
	
	private let date = Date()
	
	private var dateFormatter: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		guard let date = formatter.date(from: time) else {return ""}
		return formatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
	}
	
	var day: String {
		if dateFormatter == DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1] {
			return "Today"
		}
		return String(dateFormatter.prefix(upTo: dateFormatter.index(dateFormatter.startIndex, offsetBy: 3)))
	}
	
	var weatherString: String {
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
	
	var maxTemperature: String {
		return "\(Int(maxTemp))°"
	}
	
	var minTemperature: String {
		return "\(Int(minTemp))°"
	}
	
	
	init(time: String, weatherCode: Int, maxTemp: Float, minTemp: Float) {
		self.time = time
		self.weatherCode = weatherCode
		self.maxTemp = maxTemp
		self.minTemp = minTemp
	}
}
