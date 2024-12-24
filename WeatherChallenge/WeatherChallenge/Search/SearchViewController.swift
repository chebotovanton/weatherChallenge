//
//  SearchViewController.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit

// WIP: Rename to Location?
struct SearchResult: Equatable, Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}

enum SearchViewState: Equatable {
    case loading
    case error(String)
    case loaded([SearchResult])
}

protocol SearchViewModelProtocol {
    func searchQueryChanged(text: String)
    func searchResultSelected(searchResult: SearchResult)
 
    var viewState: Observable<SearchViewState> { get }
}

// TODO: I know it's possible to achieve a similar result with UISearchController, but I haven't worked with it in a while, and this crude manual approach seems to be working ok for our needs
final class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModelProtocol
    private let errorMessageView = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    private let searchResultCellIdentifier = "searchResultCellIdentifier"
    
    private var searchBar = UISearchBar()
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupTableView()
        setupAccessoryViews()
        observeSearchResults()
        
        self.updateViewState(viewState: viewModel.viewState.value)
    }
    
    private func setupSearchController() {
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchResultCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func setupAccessoryViews() {
        self.view.addSubview(errorMessageView)
        errorMessageView.centerInSuperview()
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        activityIndicator.backgroundColor = .black
        activityIndicator.layer.cornerRadius = 15
    }
    
    private func observeSearchResults() {
        viewModel.viewState.subscribe(observer: self) { [weak self] newValue, oldValue in
            guard let self = self, newValue != oldValue else { return }
            self.updateViewState(viewState: newValue)
        }
    }
    
    private func updateViewState(viewState: SearchViewState) {
        switch viewState {
        case .loading:
            // WIP: This isn't working as expected
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            errorMessageView.isHidden = true
            tableView.isHidden = true
        case .error(let errorMessage):
            activityIndicator.isHidden = true
            errorMessageView.isHidden = false
            tableView.isHidden = true
            errorMessageView.text = errorMessage
        case .loaded(_):
            activityIndicator.isHidden = true
            errorMessageView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    // WIP: This is the wrong method to have, silly!
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let queryText = searchBar.text, !queryText.isEmpty {
            viewModel.searchQueryChanged(text: queryText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let queryText = searchBar.text, !queryText.isEmpty {
            viewModel.searchQueryChanged(text: queryText)
        }
    }
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
        
        let searchResult = viewModel.searchResults[indexPath.item]
        configureCell(cell: cell, searchResult: searchResult)
        
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, searchResult: SearchResult) {
        cell.textLabel?.text = searchResult.name
        // WIP: This ain't working. Introduce a custom cell?
        cell.detailTextLabel?.text = searchResult.country
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResults = viewModel.searchResults
        guard indexPath.item < searchResults.count else { return }
        let searchResult = searchResults[indexPath.item]
        viewModel.searchResultSelected(searchResult: searchResult)
    }
}

private extension SearchViewModelProtocol {
    var searchResults: [SearchResult] {
        guard case .loaded(let searchResults) = viewState.value else { return [] }
        return searchResults
    }
}

// WIP: Pre-fill the table view with the favourites? Instead of tabbar?
