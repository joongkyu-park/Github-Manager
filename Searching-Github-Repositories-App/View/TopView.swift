//
//  TopView.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/21.
//

import UIKit
import SwiftKeychainWrapper

class TopView: UIView {
    //MARK: - UI Definition
    private let appNameLabel = UILabel()
    private let loginButton = UIButton()
    private let githubImageView = UIImageView()
    private let horizontalStackView = UIStackView()
    
    //MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        
        setUpView()
        setUpAppNameLabel()
        setUpGithubImageView()
        setUpHorizontalStackView()
        setUpLoginButon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Set Up
extension TopView {
    //MARK: - View
    func setUpView() {
        self.backgroundColor = Constants.Color.mainColor
        NotificationCenter.default.addObserver(self, selector: #selector(notAuthenticatedUserNoti), name: .notAuthenticatedUserNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authenticatedUserNoti), name: .authenticatedUserNoti, object: nil)
    }
    @objc func notAuthenticatedUserNoti(_ notification: Notification) {
        self.loginButton.setTitle(Constants.String.login, for: .normal)
    }
    @objc func authenticatedUserNoti(_ notification: Notification) {
        self.loginButton.setTitle(Constants.String.logout, for: .normal)
    }
    
    func addSubViews() {
        self.addSubview(horizontalStackView)
        self.addSubview(loginButton)
    }
    
    //MARK: - App Name Label
    func setUpAppNameLabel() {
        appNameLabel.text = Constants.String.appTitle
        appNameLabel.font = UIFont(name: Constants.FontName.PretendardBold, size: 20)
        appNameLabel.textColor = .white
    }
    
    //MARK: - Github ImageView
    func setUpGithubImageView() {
        githubImageView.image = Constants.Image.github
        githubImageView.tintColor = .white
        
        setGithubImageViewConstraints()
    }
    
    func setGithubImageViewConstraints() {
        NSLayoutConstraint.activate([
            githubImageView.widthAnchor.constraint(equalToConstant: 25),
            githubImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    //MARK: - Horizontal StackView
    func setUpHorizontalStackView() {
        horizontalStackView.addArrangedSubview(githubImageView)
        horizontalStackView.addArrangedSubview(appNameLabel)
        horizontalStackView.spacing = 5
        horizontalStackView.axis = .horizontal
        
        setHorizontalStackViewConstraints()
    }
    func setHorizontalStackViewConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            horizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    //MARK: - Login Button
    func setUpLoginButon() {
        appNameLabel.textColor = .white
        if KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) == nil {
            loginButton.setTitle(Constants.String.login, for: .normal)
        }
        else {
            loginButton.setTitle(Constants.String.logout, for: .normal)
        }
        loginButton.titleLabel?.font = UIFont(name: Constants.FontName.PretendardRegular, size: 10)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
        
        setLoginButonConstraints()
    }
    
    func setLoginButonConstraints() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            loginButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

//MARK: - Actions
extension TopView {
    @objc func loginButtonDidTapped(sender: UIButton!) {
        if KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) == nil {
            LoginManager.shared.login()
        }
        else {
            showAlertForLogout()
        }
    }
    
    //MARK: - Logout Alert
    func showAlertForLogout() {
        let alert = UIAlertController(title: Constants.String.alertForLogout, message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: Constants.String.logout, style: UIAlertAction.Style.default, handler:
                                            { _ in
            LoginManager.shared.logout()
        })
        let cancelAction = UIAlertAction(title: Constants.String.cancel, style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        deleteAction.setValue(UIColor.red, forKey: Constants.String.alertActionSetValue)
        cancelAction.setValue(Constants.Color.mainColor, forKey: Constants.String.alertActionSetValue)
        
        guard let rootViewController = self.window?.rootViewController else { return }
        rootViewController.present(alert, animated: true, completion: nil)
    }
}
