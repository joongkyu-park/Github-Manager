//
//  ProfileViewModel.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/22.
//

import Foundation
import RxSwift

class ProfileViewModel {
    //MARK: - Properties
    private var page: Int = 1
    let starredRepositoriesSubject = PublishSubject<[RepositoryItem]>()
    let userInfoSubject = PublishSubject<UserItem>()
    
    //MARK: - Instances
    private let disposeBag = DisposeBag()
}

//MARK: - Functions
extension ProfileViewModel {
    //MARK: - Fetch Data
    func fetchStarredRepositories() {
        NetworkManager.shared.getStarredRepositories(page: page)
            .subscribe(onNext: {
                self.starredRepositoriesSubject.onNext($0)
            }, onError: { error in
                NotificationCenter.default.post(name: .notAuthenticatedUserNoti, object: nil)
            }).disposed(by: disposeBag)
    }
    
    func fecthUserInfo() {
        NetworkManager.shared.getUserInfo()
            .subscribe(onNext: {
                self.userInfoSubject.onNext($0)
            }, onError: { error in
                NotificationCenter.default.post(name: .notAuthenticatedUserNoti, object: nil)
            }).disposed(by: disposeBag)
    }
}
