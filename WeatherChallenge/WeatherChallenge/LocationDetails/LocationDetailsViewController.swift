//
//  LocationDetailsViewController.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

protocol LocationDetailsViewModelProtocol {
    // TODO: The list of items is static, so no need to have it observable
    var viewData: LocationDetailsViewData { get }
    
    func viewDidAppear()
}

protocol WeatherItemProtocol {
    func registerCell(tableView: UITableView)
    func preferredCellHeight() -> CGFloat
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

// TODO: This approach allows us to add more items like current weather/forecast/aurora data/air pollution to the list without changing the controller code
struct LocationDetailsViewData {
    let weatherItems: [WeatherItemProtocol]
}

final class LocationDetailsViewController: UIViewController {
    private let viewModel: LocationDetailsViewModelProtocol
    private let tableView = UITableView()
    
    init(viewModel: LocationDetailsViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    private func setupTableView() {
        viewModel.viewData.weatherItems.forEach { $0.registerCell(tableView: tableView) }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension LocationDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewData.weatherItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherItems = viewModel.viewData.weatherItems
        guard indexPath.item < weatherItems.count else {
            return UITableViewCell()
        }
        let item = weatherItems[indexPath.item]
        return item.createCell(tableView: tableView, indexPath: indexPath)
    }
}


extension LocationDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let weatherItems = viewModel.viewData.weatherItems
        guard indexPath.item < weatherItems.count else { return 0 }
        let item = weatherItems[indexPath.item]
        
        return item.preferredCellHeight()
    }
    
// TODO: We can use something like this to postpone the data loading if we have more items than 2
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let weatherItems = viewModel.viewData.weatherItems
//        guard indexPath.item < weatherItems.count else {
//            return UITableViewCell()
//        }
//        let item = weatherItems[indexPath.item]
//        item.cellWillAppearOnScreen()
//    }
    
}

// WIP: Disable cell selection
