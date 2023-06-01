//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import Foundation

struct WeatherResponse: Codable {
	let daily: DailyWeather
	let hourly: HourlyWeather
}

struct DailyWeather: Codable {
	let time: [String]
	let weatherCode: [Int]
	let maxTemperature: [Float]
	let minTemperature: [Float]
	
	enum CodingKeys: String, CodingKey {
		case time
		case weatherCode = "weathercode"
		case maxTemperature = "temperature_2m_max"
		case minTemperature = "temperature_2m_min"
	}
}

struct HourlyWeather: Codable {
	let time: [String]
	let weatherCode: [Int]
	let temperature: [Float]
	
	enum CodingKeys: String, CodingKey {
		case time
		case weatherCode = "weathercode"
		case temperature = "temperature_2m"
	}
}
