//
//  SearchViewController.swift
//  WeatherChallenge
//
//  Created by Anton Chebotov on 23/12/2024.
//

import UIKit
import Combine

struct Location: Equatable, Codable {
    let name: String
    let country: String
    let state: String
    let lat: Double
    let lon: Double
}

enum SearchViewState: Equatable {
    case loading
    case error(String)
    case loaded([Location])
}

protocol SearchViewModelProtocol {
    func searchQueryChanged(text: String?)
    func searchResultSelected(Location: Location)
    var viewState: CurrentValueSubject<SearchViewState, Never> { get }
}

// TODO: Seems like it's possible to achieve a similar result with UISearchController, but I haven't worked with it in a while, and this crude manual approach seems to be working ok for our needs
final class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModelProtocol
    private let errorMessageView = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let searchResultCellIdentifier = "searchResultCellIdentifier"
    private let searchBar = UISearchBar()
    private var viewStateObserver: AnyCancellable?

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"
        
        setupSearchController()
        setupTableView()
        setupAccessoryViews()

        viewStateObserver = viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] newValue in self?.updateViewState(viewState: newValue) }
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
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: searchResultCellIdentifier)
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
        activityIndicator.color = .black
    }

    private func updateViewState(viewState: SearchViewState) {
        switch viewState {
        case .loading:
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQueryChanged(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQueryChanged(text: searchBar.text)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellIdentifier, for: indexPath)

        guard indexPath.item < viewModel.searchResults.count,
                let typedCell = cell as? SearchResultCell else {
            return cell
        }
        
        let location = viewModel.searchResults[indexPath.item]
        typedCell.configure(location: location)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResults = viewModel.searchResults
        guard indexPath.item < searchResults.count else { return }
        let Location = searchResults[indexPath.item]
        viewModel.searchResultSelected(Location: Location)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchResultCell.preferredCellHeight
    }
}

private extension SearchViewModelProtocol {
    var searchResults: [Location] {
        guard case .loaded(let searchResults) = viewState.value else { return [] }
        return searchResults
    }
}
