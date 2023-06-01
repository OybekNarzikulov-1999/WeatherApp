//
//  MainTableViewCell.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit

class MainTableViewCell: UITableViewCell {
	
	private let weatherImage: UIImageView = {
		let image = UIImageView()
		image.clipsToBounds = true
		image.image = UIImage(named: "sun")
		return image
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Today:"
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
	private let temperatureMinLabel: UILabel = {
		let label = UILabel()
		label.text = "-10°"
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
	private let arrowLabel: UILabel = {
		let label = UILabel()
		label.text = "---------->"
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.textColor = .black
		return label
	}()
	
	private let temperatureMaxLabel: UILabel = {
		let label = UILabel()
		label.text = "40°"
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.textColor = .black
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(weatherImage)
		contentView.addSubview(titleLabel)
		contentView.addSubview(temperatureMinLabel)
		contentView.addSubview(arrowLabel)
		contentView.addSubview(temperatureMaxLabel)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		weatherImage.image = nil
		titleLabel.text = nil
		temperatureMinLabel.text = nil
		temperatureMaxLabel.text = nil
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		weatherImage.snp.makeConstraints { make in
			make.centerY.equalTo(contentView)
			make.left.equalTo(15)
			make.height.width.equalTo(30)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalTo(contentView)
			make.left.equalTo(weatherImage.snp.right).offset(15)
		}
		
		temperatureMinLabel.snp.makeConstraints { make in
			make.centerY.equalTo(contentView)
			make.left.equalTo(contentView.snp.centerX).offset(-45)
		}
		
		arrowLabel.snp.makeConstraints { make in
			make.centerY.equalTo(contentView)
			make.left.equalTo(contentView.snp.centerX).offset(8)
		}
		
		temperatureMaxLabel.snp.makeConstraints { make in
			make.centerY.equalTo(contentView)
			make.right.equalTo(contentView.snp.right).offset(-20)
		}
	}
	
	func update(_ viewModel: MainCellViewModel) {
		weatherImage.image = UIImage(named: viewModel.weatherString)
		titleLabel.text = viewModel.day
		temperatureMinLabel.text = viewModel.minTemperature
		temperatureMaxLabel.text = viewModel.maxTemperature
	}
}
