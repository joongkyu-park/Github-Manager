//
//  ProfileViewController.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {
    //MARK: - UI Definition
    private let topView = TopView()
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let userBioLabel = UILabel()
    private let followersIconImageView = UIImageView()
    private let followersLabel = UILabel()
    private let starredRepositoriesTableView = UITableView()
    private let verticalStackView = UIStackView()
    private let followerHorizontalStackView = UIStackView()
    private let notAuthenticatedUserView = UIView()
    private let loginGuideLabel = UILabel()
    private let loginButton = UIButton()
    private let loginGuideStackView = UIStackView()
    
    //MARK: - Instances
    private let profileViewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        
        setUpViewController()
        setUpTopView()
        setUpUserImageView()
        setUpUserNaemeLabel()
        setUpUserBioLabel()
        setUpFollowersIconImageView()
        setUpFollowersLabel()
        setUpStarredRepositoriesTableView()
        setUpVerticalStackView()
        setUpFollowerHorizontalStackView()
        setUpNotAuthenticatedUserView()
        setUpLoginGuideLabel()
        setUpLoginButton()
        setUpLoginGuideStackView()
        
        bindStarredRepositoriesTableView()
        bindUserInfoViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileViewModel.fetchStarredRepositories()
    }
}

//MARK: - Set Up
extension ProfileViewController {
    //MARK: - ViewController
    func setUpViewController() {
        self.view.backgroundColor = .white
        self.profileViewModel.fetchStarredRepositories()
        self.profileViewModel.fecthUserInfo()
        
        if KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) == nil {
            self.setForNotAuthenticatedUser()
        }
        else {
            self.setForAuthenticatedUser()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notAuthenticatedUserNoti), name: .notAuthenticatedUserNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authenticatedUserNoti), name: .authenticatedUserNoti, object: nil)
    }
    @objc func notAuthenticatedUserNoti(_ notification: Notification) {
        self.setForNotAuthenticatedUser()
    }
    @objc func authenticatedUserNoti(_ notification: Notification) {
        self.setForAuthenticatedUser()
        self.profileViewModel.fecthUserInfo()
        self.profileViewModel.fetchStarredRepositories()
    }
    
    func addSubViews() {
        self.view.addSubview(userImageView)
        self.view.addSubview(topView)
        self.view.addSubview(followerHorizontalStackView)
        self.view.addSubview(starredRepositoriesTableView)
        self.view.addSubview(verticalStackView)
        self.view.addSubview(notAuthenticatedUserView)
    }
    
    //MARK: - Data Binding
    func bindUserInfoViews(){
        profileViewModel.userInfoSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] userItem in
                self?.userNameLabel.text = userItem.name
                self?.userBioLabel.text = userItem.bio
                self?.userImageView.load(url: URL(string: userItem.avatarUrl)!)
                self?.followersLabel.text = String("\(Constants.String.followers) \(userItem.followers) \(Constants.String.following) \(userItem.following)")
            })
            .disposed(by: disposeBag)
    }
    
    func bindStarredRepositoriesTableView() {
        profileViewModel.starredRepositoriesSubject
            .observe(on: MainScheduler.instance)
            .bind(to: starredRepositoriesTableView.rx.items(cellIdentifier: RepositoriesTableViewCell.identifier, cellType: RepositoriesTableViewCell.self)) { index, item, cell in
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
    
    //MARK: - Set View Regarding Authentication
    func setForAuthenticatedUser() {
        self.notAuthenticatedUserView.isHidden = true
        
        self.userImageView.isHidden = false
        self.verticalStackView.isHidden = false
        self.starredRepositoriesTableView.isHidden = false
    }
    func setForNotAuthenticatedUser() {
        self.notAuthenticatedUserView.isHidden = false
        
        self.userImageView.isHidden = true
        self.verticalStackView.isHidden = true
        self.starredRepositoriesTableView.isHidden = true
    }
    
    //MARK: - Top View
    func setUpTopView() {
        setTopViewConstraints()
    }
    
    func setTopViewConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 50),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    //MARK: - User ImageView
    func setUpUserImageView() {
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 35
        setUserImageViewConstraints()
    }
    
    func setUserImageViewConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    //MARK: - User Name Label
    func setUpUserNaemeLabel() {
        userNameLabel.numberOfLines = 0
        userNameLabel.font = UIFont(name: Constants.FontName.PretendardBold, size: 15)
        userNameLabel.textColor = Constants.Color.basicBlackFontColor
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - User Bio Label
    func setUpUserBioLabel() {
        userBioLabel.numberOfLines = 0
        userBioLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 12)
        userBioLabel.textColor = Constants.Color.basicBlackFontColor
        userBioLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Followers Icon ImageView
    func setUpFollowersIconImageView() {
        followersIconImageView.image = Constants.Image.followers
        followersIconImageView.tintColor = Constants.Color.addtionalRepoInfoFontColor
        
        setFollowersIconImageViewConstraints()
    }
    
    func setFollowersIconImageViewConstraints() {
        followersIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followersIconImageView.widthAnchor.constraint(equalToConstant: 12),
            followersIconImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    //MARK: - Followers Label
    func setUpFollowersLabel() {
        followersLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 10)
        followersLabel.textColor = Constants.Color.addtionalRepoInfoFontColor
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Starred Repositories TableView
    func setUpStarredRepositoriesTableView() {
        starredRepositoriesTableView.dataSource = nil
        starredRepositoriesTableView.register(RepositoriesTableViewCell.self, forCellReuseIdentifier: RepositoriesTableViewCell.identifier)
        starredRepositoriesTableView.estimatedRowHeight = 300
        starredRepositoriesTableView.rowHeight = UITableView.automaticDimension
        
        setStarredRepositoriesTableViewConstraints()
    }
    
    func setStarredRepositoriesTableViewConstraints() {
        starredRepositoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starredRepositoriesTableView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            starredRepositoriesTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            starredRepositoriesTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            starredRepositoriesTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Vertical StackView
    func setUpVerticalStackView() {
        _ = [userNameLabel, userBioLabel, followerHorizontalStackView].map { self.verticalStackView.addArrangedSubview($0) }
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        
        setVerticalStackViewConstraints()
    }
    func setVerticalStackViewConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            verticalStackView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor)
        ])
    }
    
    //MARK: - Follower Horizontal StackView
    func setUpFollowerHorizontalStackView() {
        _ = [followersIconImageView, followersLabel].map { self.followerHorizontalStackView.addArrangedSubview($0) }
        followerHorizontalStackView.axis = .horizontal
        followerHorizontalStackView.spacing = 5
        followerHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Login Guide Label
    func setUpLoginGuideLabel() {
        loginGuideLabel.text = Constants.String.loginGuide
        loginGuideLabel.font = UIFont(name: Constants.FontName.PretendardBold, size: 20)
        loginGuideLabel.textColor = Constants.Color.mainColor
        loginGuideLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Login Button
    func setUpLoginButton() {
        loginButton.setTitle(Constants.String.login, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: Constants.FontName.PretendardRegular, size: 15)
        loginButton.tintColor = Constants.Color.basicBlackFontColor
        loginButton.backgroundColor = Constants.Color.repoIconImageViewColor
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonDidTapped(sender: UIButton!) {
        LoginManager.shared.login()
    }
    
    //MARK: - Login Guide StackView
    func setUpLoginGuideStackView() {
        _ = [loginGuideLabel, loginButton].map { self.loginGuideStackView.addArrangedSubview($0) }
        loginGuideStackView.axis = .vertical
        loginGuideStackView.spacing = 10
        
        setLoginGuideStackViewConstraints()
    }
    
    func setLoginGuideStackViewConstraints() {
        loginGuideStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginGuideStackView.centerXAnchor.constraint(equalTo: notAuthenticatedUserView.centerXAnchor),
            loginGuideStackView.centerYAnchor.constraint(equalTo: notAuthenticatedUserView.centerYAnchor, constant: -60)
        ])
    }
    //MARK: - Not Authenticated User View
    func setUpNotAuthenticatedUserView() {
        notAuthenticatedUserView.backgroundColor = .white
        notAuthenticatedUserView.addSubview(loginGuideStackView)
        
        setNotAuthenticatedUserView()
    }
    
    func setNotAuthenticatedUserView() {
        notAuthenticatedUserView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notAuthenticatedUserView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            notAuthenticatedUserView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            notAuthenticatedUserView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            notAuthenticatedUserView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//MARK: - for User Image
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

//MARK: - for canvas
import SwiftUI
struct ProfileViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProfileViewController
    
    func makeUIViewController(context: Context) -> ProfileViewController {
        return ProfileViewController()
    }
    
    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
    }
}

@available(iOS 13.0.0, *)
struct ProfileViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileViewControllerRepresentable()
    }
}
