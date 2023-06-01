//
//  DetailCollectionViewCell.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 01/06/23.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
	
	
	private let timeLabel: UILabel = {
		let label = UILabel()
		label.text = "Now"
		label.font = .systemFont(ofSize: 20, weight: .semibold)
		label.textAlignment = .center
		label.textAlignment = .center
		return label
	}()
	
	private let temperatureLabel: UILabel = {
		let label = UILabel()
		label.text = "27°"
		label.font = .systemFont(ofSize: 24, weight: .semibold)
		label.textAlignment = .center
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.layer.cornerRadius = 10
		contentView.layer.borderColor = UIColor.black.cgColor
		contentView.layer.borderWidth = 1
		contentView.backgroundColor = .white
		
		
		contentView.addSubview(timeLabel)
		contentView.addSubview(temperatureLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		timeLabel.text = nil
		temperatureLabel.text = nil
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		timeLabel.snp.makeConstraints { make in
			make.centerX.equalTo(contentView)
			make.top.equalTo(20)
			make.width.equalTo(contentView.snp.width).offset(-10)
		}
		
		temperatureLabel.snp.makeConstraints { make in
			make.centerX.equalTo(contentView)
			make.bottom.equalTo(-20)
			make.width.equalTo(contentView.snp.width).offset(-10)
		}
		
	}
	
	func update(_ viewModel: DetailCellViewModel) {
		timeLabel.text = viewModel.hour
		temperatureLabel.text = viewModel.temp
	}
	
}
