//
//  UIAlertController+Extensions.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 01/06/23.
//

import UIKit

extension UIAlertController {
	
	func doesInternetWork(status: String, style: UIAlertAction.Style){
		let alert = UIAlertController(title: "Internet is \(status)", message: "Internet is \(status)", preferredStyle: .alert)
		let action = UIAlertAction(title: "Done", style: style)
		alert.addAction(action)
		self.present(alert, animated: true)
	}
	
	func showError(errorString: String) {
		let alert = UIAlertController(title: "Error", message: "\(errorString)", preferredStyle: .alert)
		let action = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(action)
		self.present(alert, animated: true)
	}
	
}
