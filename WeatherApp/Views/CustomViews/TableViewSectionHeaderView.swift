//
//  TableViewSectionHeaderView.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit
import SnapKit

enum NumberOfDays {
	case three
	case five
	case seven
}

class TableViewSectionHeaderView: UITableViewHeaderFooterView {
	
	var filterDays: ((NumberOfDays) -> ())?
	
	private lazy var filterMenu: UIMenu = {
		
		let threeDays = UIAction(title: "3 Days") { (action) in
			self.filterDays?(.three)
		}
		
		let fiveDays = UIAction(title: "5 Days") { (action) in
			self.filterDays?(.five)
		}
		let sevenDays = UIAction(title: "7 Days") { (action) in
			self.filterDays?(.seven)
		}
		
		let menu = UIMenu(title: "Select period", options: .displayInline, children: [threeDays , fiveDays , sevenDays])

		return menu
	}()

	var button: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Filter", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
		button.tintColor = .red
		return button
	}()
	
	var title: UILabel = {
		let title = UILabel()
		title.font = .systemFont(ofSize: 20, weight: .semibold)
		title.textColor = .black
		title.text = "Weather for 7 days"
		return title
	}()

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		button.menu = filterMenu
		button.showsMenuAsPrimaryAction = true
		
		contentView.backgroundColor = UIColor(named: "TableSectionHeaderColor")
		contentView.addSubview(button)
		contentView.addSubview(title)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		button.snp.makeConstraints { make in
			make.top.equalTo(6)
			make.right.equalTo(-15)
			make.height.equalTo(22)
		}
		
		title.snp.makeConstraints { make in
			make.top.equalTo(5)
			make.left.equalTo(15)
		}
	}
	
}
