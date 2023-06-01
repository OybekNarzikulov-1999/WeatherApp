//
//  Service.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit
import CoreData

protocol ServiceProtocol{
	
}

final class Service {
	
	enum CustomError: LocalizedError {
		case noData
		case wrongResponse
		case emptyCoreData
	}
	
	private let context = CoreDataManager.shared.context
	
	func getWeatherData(completion: @escaping(Result<WeatherResponse, Error>) -> Void) {
		
		let fetchRequest: NSFetchRequest<CachedResponse> = CachedResponse.fetchRequest()
		
		do {
			let cachedResponse = try context.fetch(fetchRequest)
			guard let cachedResponse = cachedResponse.first, let responseData = cachedResponse.responseData else {
				completion(.failure(CustomError.emptyCoreData))
				return
			}
			do {
				let forecast = try JSONDecoder().decode(WeatherResponse.self, from: responseData)
				completion(.success(forecast))
			} catch let error {
				completion(.failure(error))
			}
		} catch {
			print("Core data error")
		}
	}
	
	func updateWeatherData(lat: Double, lon: Double, timezone: String, completion: @escaping(Result<WeatherResponse, Error>) -> Void){
		guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&hourly=temperature_2m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=\(timezone)") else {return}
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(CustomError.noData))
				return
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				completion(.failure(CustomError.wrongResponse))
				return
			}
			
			do {
				let forecast = try JSONDecoder().decode(WeatherResponse.self, from: data)
				completion(.success(forecast))
			} catch let error {
				completion(.failure(error))
			}
			
			// Сохранение ответа в CoreData
			let cachedResponse = CachedResponse(context: self.context)
			cachedResponse.url = url.absoluteString
			cachedResponse.responseData = data
			do {
				try self.context.save()
			} catch {
				print("\(error)")
			}
			
		}.resume()
	}
	
}
