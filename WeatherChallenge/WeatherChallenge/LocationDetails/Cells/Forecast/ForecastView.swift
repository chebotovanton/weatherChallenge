//
//  ForecastView.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

// TODO: We can introduce a ViewModel for this view to handle analytics event during scrolling or user actions. Didn't really need it for the exercise
final class ForecastView: UIView, UICollectionViewDataSource {
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private let collectionView: UICollectionView
    private var viewData: ForecastData?
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
        
        collectionView.register(ForecastItemViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewData: ForecastData) {
        self.viewData = viewData
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewData?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        guard let forecastItemCell = cell as? ForecastItemViewCell,
              let forecastItems = self.viewData?.list,
              indexPath.item < forecastItems.count else { return cell }
        
        let forecastItem = forecastItems[indexPath.item]
        forecastItemCell.configure(forecastItem: forecastItem)
        
        return forecastItemCell
    }
}

final class ForecastItemViewCell: UICollectionViewCell {
    private let mainLabel = UILabel()
    private let tempLabel = UILabel()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                mainLabel,
                tempLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    func configure(forecastItem: ForecastItem) {
        if stackView.superview == nil {
            addSubview(stackView)
            stackView.pinToSuperviewEdges()
        }
        
        mainLabel.text = forecastItem.weather.first?.main ?? "Undefined"
        tempLabel.text = String(forecastItem.main.temp)
    }
}

// WIP: Limit the number of forecast items. How to get daily items, not 3h ones?
