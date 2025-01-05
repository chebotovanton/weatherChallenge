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
    private var forecastData: ForecastData?
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 120)
        layout.minimumInteritemSpacing = 8
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
    
    func configure(forecastData: ForecastData) {
        self.forecastData = forecastData
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecastData?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        guard let forecastItemCell = cell as? ForecastItemViewCell,
              let forecastItems = self.forecastData?.list,
              indexPath.item < forecastItems.count else { return cell }
        
        let forecastItem = forecastItems[indexPath.item]
        // WIP: ForecastView shouldn't know about the viewModel creation
        let viewModel = ForecastItemCellViewModel(forecastItem: forecastItem)
        forecastItemCell.configure(viewModel: viewModel)
        
        return forecastItemCell
    }
}

