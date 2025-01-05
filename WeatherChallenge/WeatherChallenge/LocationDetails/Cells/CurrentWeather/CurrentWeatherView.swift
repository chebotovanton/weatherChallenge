//
//  CurrentWeatherView.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 05/01/2025.
//

import UIKit

final class CurrentWeatherView: UIView {
    struct ViewData {
        let highLowViewData: HighLowView.ViewData
        let icon: UIImage?
        let weatherDescription: String
        let tempDescription: String
    }

    final class HighLowView: UIView {
        struct ViewData {
            let highTempDescription: String
            let lowTempDescription: String
        }

        // TODO: Would be nice to introduce some styling-ability by injecting styles into every view and combining those styles for the higher-level views
        private let highLabel = UILabel()
        private let lowLabel = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)

            let stackView = UIStackView(
                arrangedSubviews: [
                    {
                        let label = UILabel()
                        label.text = "High: "
                        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        return label
                    }(),
                    highLabel,
                    {
                        let label = UILabel()
                        label.text = "Low: "
                        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
                        return label
                    }(),
                    lowLabel
                ]
            )
            addSubview(stackView)
            stackView.pinToSuperviewEdges()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.spacing = 16

            highLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            lowLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(viewData: ViewData) {
            highLabel.text = viewData.highTempDescription
            lowLabel.text = viewData.lowTempDescription
        }
    }

    private let iconView = UIImageView()
    private let descriptionLabel = UILabel()
    private let tempLabel = UILabel()
    private let highLowView = HighLowView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView(
            arrangedSubviews: [
                iconView,
                descriptionLabel,
                tempLabel,
                highLowView
            ]
        )
        addSubview(stackView)
        stackView.pinToSuperviewEdges(insets: UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16))
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        tempLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewData: ViewData) {
        iconView.image = viewData.icon
        descriptionLabel.text = viewData.weatherDescription
        tempLabel.text = viewData.tempDescription
        highLowView.configure(viewData: viewData.highLowViewData)
    }
}
