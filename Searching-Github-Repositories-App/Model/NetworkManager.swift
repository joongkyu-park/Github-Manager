//
//  NetworkManager.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/19.
//

import Foundation
import Alamofire
import RxSwift
import SwiftKeychainWrapper

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getSearchedRepositories(searchTerm: String, page: Int) -> Observable<RepositoryDataItem> {
        return Observable.create { emitter in
            AF.request(Constants.Network.Repositories.urlStringForSearched,
                       method: .get,
                       parameters: [Constants.Network.Repositories.parametersKeyForSearchTerm: searchTerm,
                                    Constants.Network.Repositories.parametersKeyForPerPage: Constants.Network.Repositories.perPage,
                                    Constants.Network.Repositories.parametersKeyForPage: page],
                       headers: Constants.Network.headers).responseString { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else { return }
                        let responseDecoded = try JSONDecoder().decode(RepositoryDataItem.self, from: data)
                        emitter.onNext(responseDecoded)
                    } catch let error {
                        emitter.onError(error)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getStarredRepositories(page: Int) -> Observable<RepositoryItems> {
        return Observable.create { emitter in
            AF.request(Constants.Network.Repositories.urlStringForStarred,
                       method: .get,
                       parameters: [Constants.Network.Repositories.parametersKeyForPerPage: Constants.Network.Repositories.perPage,
                                    Constants.Network.Repositories.parametersKeyForPage: page],
                       headers: [Constants.Network.Key.accept: Constants.Network.Value.acceptValue,
                                 Constants.Network.Key.authorization: "\(Constants.Network.Value.authorizationType) \(KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) ?? "")"]).responseString { response in
                switch response.result {
                case .success:
                    do {
                        guard let statusCode = response.response?.statusCode else { return }
                        if statusCode == 401 {
                            LoginManager.shared.logout()
                            emitter.onError(AuthenticationError.invalidAuthentication)
                        }
                        guard let data = response.data else { return }
                        let responseDecoded = try JSONDecoder().decode(RepositoryItems.self, from: data)
                        emitter.onNext(responseDecoded)
                    } catch let error {
                        emitter.onError(error)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getUserInfo() -> Observable<UserItem> {
        return Observable.create { emitter in
            AF.request(Constants.Network.UserInfo.urlString,
                       method: .get,
                       headers: [Constants.Network.Key.accept: Constants.Network.Value.acceptValue,
                                 Constants.Network.Key.authorization: "\(Constants.Network.Value.authorizationType) \(KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) ?? "")"]).responseString { response in
                switch response.result {
                case .success:
                    do {
                        guard let statusCode = response.response?.statusCode else { return }
                        if statusCode == 401 {
                            LoginManager.shared.logout()
                            emitter.onError(AuthenticationError.invalidAuthentication)
                        }
                        guard let data = response.data else { return }
                        let responseDecoded = try JSONDecoder().decode(UserItem.self, from: data)
                        emitter.onNext(responseDecoded)
                    } catch let error{
                        emitter.onError(error)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getIsStarred(owner: String, repo: String) -> Observable<Bool> {
        return Observable.create { emitter in
            let urlString = Constants.Network.Starring.urlStringForCheckcingIsStarred + "/\(owner)/\(repo)"
            AF.request(urlString,
                       method: .get,
                       headers: [Constants.Network.Key.accept: Constants.Network.Value.acceptValue,
                                 Constants.Network.Key.authorization: "\(Constants.Network.Value.authorizationType) \(KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) ?? "")"]).response { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 204 {
                        emitter.onNext(true)
                    }
                    else if statusCode == 401 {
                        LoginManager.shared.logout()
                        emitter.onError(AuthenticationError.invalidAuthentication)
                    }
                    else {
                        emitter.onNext(false)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func putStarring(owner: String, repo: String) -> Observable<Bool> {
        return Observable.create { emitter in
            let urlString = Constants.Network.Starring.urlStringForCheckcingIsStarred + "/\(owner)/\(repo)"
            AF.request(urlString,
                       method: .put,
                       headers: [Constants.Network.Key.accept: Constants.Network.Value.acceptValue,
                                 Constants.Network.Key.authorization: "\(Constants.Network.Value.authorizationType) \(KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) ?? "")"]).response { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 204 {
                        emitter.onNext(true)
                    }
                    else if statusCode == 401 {
                        LoginManager.shared.logout()
                        emitter.onError(AuthenticationError.invalidAuthentication)
                    }
                    else {
                        emitter.onNext(false)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteStarring(owner: String, repo: String) -> Observable<Bool> {
        return Observable.create { emitter in
            let urlString = Constants.Network.Starring.urlStringForCheckcingIsStarred + "/\(owner)/\(repo)"
            AF.request(urlString,
                       method: .delete,
                       headers: [Constants.Network.Key.accept: Constants.Network.Value.acceptValue,
                                 Constants.Network.Key.authorization: "\(Constants.Network.Value.authorizationType) \(KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) ?? "")"]).response { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 204 {
                        emitter.onNext(true)
                    }
                    else if statusCode == 401 {
                        LoginManager.shared.logout()
                        emitter.onError(AuthenticationError.invalidAuthentication)
                    }
                    else {
                        emitter.onNext(false)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
