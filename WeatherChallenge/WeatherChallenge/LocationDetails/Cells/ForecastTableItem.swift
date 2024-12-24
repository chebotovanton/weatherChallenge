//
//  ForecastTableItem.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 24/12/2024.
//

import UIKit

final class ForecastTableItem: WeatherItemProtocol {
    private let forecastCellIdentifier = "forecastCellIdentifier"
    
    func registerCell(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: forecastCellIdentifier)
    }
    
    func preferredCellHeight() -> CGFloat { 120 }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
