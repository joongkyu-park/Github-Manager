//
//  SearchViewModel.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/21.
//

import Foundation
import RxSwift

class SearchViewModel {
    //MARK: - Properties
    private var page: Int = 1
    let totalCountSubject = PublishSubject<Int>()
    let repositoriesSubject = PublishSubject<[RepositoryItem]>()
    private var searchTerm = ""
    
    //MARK: - Instances
    private let disposeBag = DisposeBag()
}

//MARK: - Functions
extension SearchViewModel {
    //MARK: - Fetch Data
    func fetchRepositories(searchTerm: String) {
        self.searchTerm = searchTerm
        if self.searchTerm != "" {
            NetworkManager.shared.getSearchedRepositories(searchTerm: searchTerm, page: page)
                .map{ repositoryDataItem in
                    repositoryDataItem.items
                }.subscribe(onNext: {
                    self.repositoriesSubject.onNext($0)
                }).disposed(by: disposeBag)
        }
    }
    
    func fetchRepositories() {
        if self.searchTerm != "" {
            NetworkManager.shared.getSearchedRepositories(searchTerm: self.searchTerm, page: page)
                .map{ repositoryDataItem in
                    repositoryDataItem.items
                }.subscribe(onNext: {
                    self.repositoriesSubject.onNext($0)
                }).disposed(by: disposeBag)
        }
    }
}
