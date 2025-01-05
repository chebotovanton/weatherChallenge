//
//  SearchResultCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 04/01/2025.
//

import UIKit

final class SearchResultCell: UITableViewCell {
    
    static let preferredCellHeight: CGFloat = 90
    
    private let contentStackView = UIStackView()
    private let weatherIcon = UIImageView()
    private let locationName = UILabel()
    private let currentTime = UILabel()
    private let temperature = UILabel()
    private let weatherDescription = UILabel()
    
    func configure(location: Location) {
        addStackViewIfNeeded()
        
        weatherIcon.image = UIImage(systemName: "cloud.rain")
        locationName.text = location.name
        currentTime.text = "09:41"
        temperature.text = "+11"
        weatherDescription.text = "Cloudy"
    }
    
    private func addStackViewIfNeeded() {
        guard contentStackView.superview == nil else { return }
        
        addSubview(contentStackView)
        contentStackView.pinToSuperviewEdges()
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .equalSpacing
        
        let nameAndTimeStack = UIStackView(
            arrangedSubviews: [
                locationName,
                currentTime
            ]
        )
        nameAndTimeStack.axis = .vertical
        
        let tempStack = UIStackView(
            arrangedSubviews: [
                temperature,
                weatherDescription
            ]
        )
        tempStack.axis = .vertical
        
        contentStackView.addArrangedSubview(weatherIcon)
        contentStackView.addArrangedSubview(nameAndTimeStack)
        contentStackView.addArrangedSubview(tempStack)
    }
}

// WIP: Weather icon
// WIP: Location name
// WIP: Local time
// WIP: Temperature
// WIP: Weather description
