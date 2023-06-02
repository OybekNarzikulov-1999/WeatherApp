//
//  DetailCollectionViewModel.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 01/06/23.
//

import Foundation


final class DetailCellViewModel {
	
	private let time: String
	private let temperature: Float
	
	private var date = Date()
	
	var hour: String {
		let weatherHourString = String(time.dropFirst(11).prefix(2))
		return weatherHourString
	}
	
	var temp: String {
		return "\(Int(temperature))"
	}
	
	
	init(time: String, temperature: Float) {
		self.time = time
		self.temperature = temperature
	}
	
}
