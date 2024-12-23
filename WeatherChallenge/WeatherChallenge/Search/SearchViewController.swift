//
//  SearchViewController.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

struct SearchResult {
    let name: String
}

protocol SearchViewModelProtocol {
    func searchQueryChanged(text: String)
 
    // WIP: Make observable
    var searchResults: [SearchResult] { get }
}

final class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModelProtocol
    private let tableView = UITableView()
    private let searchResultCellIdentifier = "searchResultCellIdentifier"
    
    private var searchController: UISearchController?
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        searchController = UISearchController(searchResultsController: self)
        
        super.viewDidLoad()
        
        setupSearchController()
        setupTableView()
    }
    
    private func setupSearchController() {
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchResultCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive,
                let text = searchController.searchBar.text,
                !text.isEmpty else { return }
        viewModel.searchQueryChanged(text: text)
    }
}

extension SearchViewController: UISearchControllerDelegate {
    // WIP: Do I need something here?
}

extension SearchViewController: UISearchBarDelegate {
    // WIP: Do I need something here?
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellIdentifier, for: indexPath)

        guard indexPath.item < viewModel.searchResults.count else {
            return cell
        }
        
        let item = viewModel.searchResults[indexPath.item]
        cell.textLabel?.text = item.name
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
}
