//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 30/05/23.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
	
	var viewModel: DetailViewModelProtocol?
	
	private let dateLabel: UILabel = {
		let label = UILabel()
		label.text = "Today"
		label.font = .systemFont(ofSize: 35, weight: .semibold)
		label.textAlignment = .center
		return label
	}()
	
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize(width: 90, height: 110)
		layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor(named: "collectionBackground")
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.layer.cornerRadius = 15
		collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectioViewCell")
		return collectionView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor(named: "TableHeaderColor")
		navigationItem.largeTitleDisplayMode = .always
		title = "Temperature"
		
		view.addSubview(dateLabel)
		view.addSubview(collectionView)
		
		viewModel?.updateCollection = { [weak self] in
			DispatchQueue.main.async { [weak self] in
				if let dateString = self?.viewModel?.date {
					self?.dateLabel.text = dateString
				}
				self?.collectionView.reloadData()
			}
		}
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		viewModel?.fetchHourlyWeather()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		dateLabel.snp.makeConstraints { make in
			make.left.equalTo(10)
			make.right.equalTo(-10)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
		}
		
		collectionView.snp.makeConstraints { make in
			make.left.equalTo(10)
			make.right.equalTo(-10)
			make.centerY.equalTo(view)
			make.height.equalTo(130)
		}
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(true)
		viewModel?.viewDidDisappear()
	}
	
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 24
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectioViewCell", for: indexPath) as? DetailCollectionViewCell, let currentViewModel = viewModel?.cell(at: indexPath) else {return UICollectionViewCell()}
		cell.update(currentViewModel)
		return cell
	}
}
