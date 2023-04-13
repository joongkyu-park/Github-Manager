//
//  LoginManager.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/18.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

struct LoginManager {
    static let shared = LoginManager()
    private init() {}
    
    func login() {
        if KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) == nil {
            requestCode()
            return
        }
    }
    
    func logout() {
        KeychainWrapper.standard.removeObject(forKey: Constants.Keychain.accessToken)
        KeychainWrapper.standard.removeObject(forKey: Constants.Keychain.code)
        NotificationCenter.default.post(name: .notAuthenticatedUserNoti, object: nil)
    }
    
    func requestCode() {
        guard let url = URL(string: Constants.Network.Login.urlStringForCode) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAccessToken() {
        DispatchQueue.global().async {
            AF.request(Constants.Network.Login.urlStringForAccessToken,
                       method: .post,
                       parameters: [Constants.Network.Key.client_id: Constants.Network.Login.client_id,
                                    Constants.Network.Key.client_secret: Constants.Network.Login.client_secret,
                                    Constants.Network.Key.code: KeychainWrapper.standard.string(forKey: Constants.Keychain.code) ?? ""],
                       headers: Constants.Network.Login.headers).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let responseDecoded = try JSONDecoder().decode([String: String].self, from: data)
                        guard let accessToken = responseDecoded[Constants.Network.Key.accessToken] else { return }
                        KeychainWrapper.standard.set(accessToken, forKey: Constants.Keychain.accessToken)
                        NotificationCenter.default.post(name: .authenticatedUserNoti, object: nil)
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
