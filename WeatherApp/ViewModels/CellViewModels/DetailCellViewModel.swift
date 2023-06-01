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
		
		let hours = String(time.dropFirst(11).prefix(2))
		if hours == "\(Calendar.current.component(.hour, from: date))"{
			return "Now"
		}
		return hours
	}
	
	var temp: String {
		return "\(Int(temperature))"
	}
	
	
	init(time: String, temperature: Float) {
		self.time = time
		self.temperature = temperature
	}
	
}
