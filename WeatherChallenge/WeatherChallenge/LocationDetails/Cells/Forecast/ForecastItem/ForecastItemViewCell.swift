//
//  ForecastItemViewCell.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import UIKit
import Combine

protocol ForecastItemCellViewModelProtocol {
    var viewData: CurrentValueSubject<ForecastItemViewCell.ViewData, Never> { get }

    func startLoadingImage()
    func cancelLoadingImage()
}

final class ForecastItemViewCell: UICollectionViewCell {
    
    struct ViewData {
        let timeDescription: String
        let icon: UIImage?
        let tempDescription: String
    }
    
    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    private var viewModel: ForecastItemCellViewModelProtocol?
    private var viewDataObserver: AnyCancellable?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                timeLabel,
                iconView,
                tempLabel
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    func configure(viewModel: ForecastItemCellViewModelProtocol) {
        setupStackViewIfNeeded()
        self.viewModel = viewModel
        
        viewDataObserver = viewModel.viewData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in self?.updateViewData(viewData: newValue) }

        viewModel.startLoadingImage()
    }
    
    private func setupStackViewIfNeeded() {
        guard stackView.superview == nil else { return }
        
        addSubview(stackView)
        stackView.pinToSuperviewEdges(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        
        timeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        timeLabel.numberOfLines = 2
        tempLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        iconView.backgroundColor = .white
        iconView.layer.cornerRadius = 8
        iconView.contentMode = .scaleAspectFit
    }
    
    private func updateViewData(viewData: ViewData) {
        timeLabel.text = viewData.timeDescription
        iconView.image = viewData.icon
        tempLabel.text = viewData.tempDescription
    }
    
    override func prepareForReuse() {
        viewModel?.cancelLoadingImage()
    }
}
