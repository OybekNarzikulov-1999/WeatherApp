//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 01/06/23.
//

import CoreData
import UIKit

final class CoreDataManager {
	
	static var shared = CoreDataManager()
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "WeatherApp")
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Persistent Container Fatal Error")
			}
		}
		return container
	}()
	
	var context: NSManagedObjectContext {
		persistentContainer.viewContext
	}
	
	func save() {
		do {
			try context.save()
		} catch {
			print("Error: \(error.localizedDescription)")
		}
	}
	
}
