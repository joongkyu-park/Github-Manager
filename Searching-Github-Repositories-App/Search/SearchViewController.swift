//
//  SearchViewController.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    //MARK: - UI Definition
    private let topView = TopView()
    private let searchBar = UISearchBar()
    private let repositoriesTableView = UITableView()
    
    //MARK: - Constants
    private let repositoriesTableViewCellHeight: CGFloat = 200
    
    //MARK: - Instances
    private let searchViewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        
        setUpViewController()
        setUpTopView()
        setUpSearchBar()
        setUpRepositoriesTableView()
        
        bindRepositoriesTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchViewModel.fetchRepositories()
    }
}

//MARK: - UI Set Up
extension SearchViewController {
    //MARK: - ViewController
    func setUpViewController() {
        self.view.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(notAuthenticatedUserNoti), name: .notAuthenticatedUserNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authenticatedUserNoti), name: .authenticatedUserNoti, object: nil)
    }
    
    @objc func notAuthenticatedUserNoti(_ notification: Notification) {
        self.searchViewModel.fetchRepositories()
    }
    @objc func authenticatedUserNoti(_ notification: Notification) {
        self.searchViewModel.fetchRepositories()
    }
    
    func addSubViews() {
        self.view.addSubview(topView)
        self.view.addSubview(searchBar)
        self.view.addSubview(repositoriesTableView)
    }
    
    //MARK: - Data Binding
    func bindRepositoriesTableView() {
        searchViewModel.repositoriesSubject
            .observe(on: MainScheduler.instance)
            .bind(to: repositoriesTableView.rx.items(cellIdentifier: RepositoriesTableViewCell.identifier, cellType: RepositoriesTableViewCell.self)) { index, item, cell in
                cell.updateRepoNameLabel(repoName: item.fullName)
                cell.updateRepoDescriptionLabel(repoDescription: item.description ?? "")
                cell.updaterepositoriesTableViewCellViewModel(name: item.name, owner: item.owner.login)
                cell.updateTopicsLabel(topics: item.topics.reduce(""){"\($0)   " + $1})
                cell.updateAdditionalRepoInfoStackView(stargrazerCount: item.stargazersCount,
                                                      language: item.language,
                                                       license: item.license?.name,
                                                      updatedAt: item.updatedAt)
                if item.topics.isEmpty {
                    cell.removeTopicsContainerStackView()
                }
                cell.bindStarButton()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Top View
    func setUpTopView() {
        setTopViewConstraints()
    }
    
    func setTopViewConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 50),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    //MARK: - SearchBar
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = Constants.String.searchBarPlaceHolder
        
        setSearchBarConstraints()
    }
    
    func setSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchBar.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20)
        ])
    }
    
    //MARK: - Repositories TableView
    func setUpRepositoriesTableView() {
        repositoriesTableView.dataSource = nil
        repositoriesTableView.register(RepositoriesTableViewCell.self, forCellReuseIdentifier: RepositoriesTableViewCell.identifier)
        repositoriesTableView.estimatedRowHeight = repositoriesTableViewCellHeight
        repositoriesTableView.rowHeight = UITableView.automaticDimension
        
        setRepositoriesTableViewConstraints()
    }
    
    func setRepositoriesTableViewConstraints() {
        repositoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repositoriesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            repositoriesTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            repositoriesTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            repositoriesTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchViewModel.fetchRepositories(searchTerm: searchBar.text ?? "")
    }
}


//MARK: - for canvas
import SwiftUI
struct SearchViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SearchViewController
    
    func makeUIViewController(context: Context) -> SearchViewController {
        return SearchViewController()
    }
    
    func updateUIViewController(_ uiViewController: SearchViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct SearechViewPreview: PreviewProvider {
    static var previews: some View {
        SearchViewControllerRepresentable()
    }
}
