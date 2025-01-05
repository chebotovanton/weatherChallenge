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
    private let locationIcon = UIImageView(image: UIImage(systemName: "location.square"))
    private let locationName = UILabel()
    private let countryName = UILabel()
    private let stateName = UILabel()
    
    func configure(location: Location) {
        setupStackViewIfNeeded()
        
        locationName.text = location.name
        countryName.text = location.country
        stateName.text = location.state
    }
    
    private func setupStackViewIfNeeded() {
        guard contentStackView.superview == nil else { return }
        
        addSubview(contentStackView)
        contentStackView.pinToSuperviewEdges(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .equalSpacing
        contentStackView.alignment = .center
        
        let nameAndCountryStack = UIStackView(
            arrangedSubviews: [
                locationName,
                countryName,
                stateName
            ]
        )
        nameAndCountryStack.axis = .vertical
        nameAndCountryStack.distribution = .equalSpacing
        nameAndCountryStack.alignment = .trailing
                
        contentStackView.addArrangedSubview(locationIcon)
        contentStackView.addArrangedSubview(nameAndCountryStack)
        
        locationName.font = UIFont.preferredFont(forTextStyle: .headline)
        countryName.font = UIFont.preferredFont(forTextStyle: .subheadline)
        stateName.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
}
