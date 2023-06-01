//
//  TableHeaderView.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit
import SnapKit

class TableHeaderView: UIView {
	
	private let weatherImage: UIImageView = {
		let image = UIImageView()
		image.clipsToBounds = true
		image.image = UIImage(named: "sun")
		return image
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Now:"
		label.font = .systemFont(ofSize: 25, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
	private let temperatureLabel: UILabel = {
		let label = UILabel()
		label.text = "--"
		label.font = .systemFont(ofSize: 23, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor(named: "TableHeaderColor")
		
		addSubview(weatherImage)
		addSubview(titleLabel)
		addSubview(temperatureLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		weatherImage.snp.makeConstraints { make in
			make.centerY.equalTo(self)
			make.left.equalTo(90)
			make.height.width.equalTo(50)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(self)
			make.left.equalTo(weatherImage.snp.right).offset(15)
		}
		
		temperatureLabel.snp.makeConstraints { make in
			make.centerY.equalTo(self)
			make.left.equalTo(titleLabel.snp.right).offset(10)
		}
	}
	
	func update(_ viewModel: TableHeaderViewModel) {
		weatherImage.image = UIImage(named: viewModel.weatherString)
		temperatureLabel.text = viewModel.temperature
	}
}
