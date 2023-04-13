//
//  RepositoriesTableViewCell.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/19.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class RepositoriesTableViewCell: UITableViewCell {
    //MARK: - UI Definition
    private let repoIconImageView = UIImageView()
    private let repoNameLabel = UILabel()
    private let repoDescriptionLabel = UILabel()
    private let topicsScrollView = UIScrollView()
    private let topicsLabel = UILabel()
    private let topicsContainerStackView = UIStackView()
    private let topicMarkLabel = PaddingLabel()
    private let addtionalRepoInfoScrollView = UIScrollView()
    private let addtionalRepoInfoStackView = UIStackView()
    private let starButton = UIButton(type: .custom)
    private let verticalStackView = UIStackView()
    private let starImageView = UIImageView()
    private let stargrazerCountLabel = UILabel()
    private let languageLabel = UILabel()
    private let licenseLabel = UILabel()
    private let updatedAtLabel = UILabel()
    
    //MARK: - Constants
    static let identifier = Constants.Id.repositoriesTableViewCell
    
    //MARK: - Instances
    private let repositoriesTableViewCellViewModel = RepositoriesTableViewCellViewModel()
    var disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()

        setUpCell()
        setUpStarButton()
        setUpRepoIconImageView()
        setUpRepoNameLabel()
        setUpRepoDescriptionLabel()
        setUpTopicsScrollView()
        setUpTopicsLabel()
        setUpTopicMarkLabel()
        setUpTopicsContainerStackView()
        setUpAdditionalRepoInfoScrollView()
        setUpAdditionalRepoInfoStackView()
        setUpVerticalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topicsContainerStackView.isHidden = false
        disposeBag = DisposeBag()
    }
}

//MARK: - Set Up
extension RepositoriesTableViewCell {
    //MARK: - Cell
    func setUpCell() {
        self.selectionStyle = .none
    }
    
    func addSubViews() {
        self.contentView.addSubview(starButton)
        self.contentView.addSubview(repoIconImageView)
        self.contentView.addSubview(verticalStackView)
    }
    
    //MARK: - Repo Icon ImageView
    func setUpRepoIconImageView() {
        repoIconImageView.image = Constants.Image.repository
        repoIconImageView.tintColor = Constants.Color.repoIconImageViewColor
        
        setRepoIconImageViewConstraints()
    }
    
    func setRepoIconImageViewConstraints() {
        repoIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repoIconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            repoIconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            repoIconImageView.heightAnchor.constraint(equalToConstant: 20),
            repoIconImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    //MARK: - Repo Name Label
    func setUpRepoNameLabel() {
        repoNameLabel.numberOfLines = 0
        repoNameLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 14)
        repoNameLabel.textColor = Constants.Color.basicBlueFontColor
        repoNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Repo Description Label
    func setUpRepoDescriptionLabel() {
        repoDescriptionLabel.numberOfLines = 0
        repoDescriptionLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 14)
        repoDescriptionLabel.textColor = Constants.Color.basicBlackFontColor
        repoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Topics ScrollView
    func setUpTopicsScrollView() {
        topicsScrollView.isScrollEnabled = true
        topicsScrollView.addSubview(topicsLabel)
        topicsScrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Topics Label
    func setUpTopicsLabel() {
        topicsLabel.numberOfLines = 0
        topicsLabel.font = UIFont(name: Constants.FontName.PretendardBold, size: 12)
        topicsLabel.textColor = Constants.Color.basicBlueFontColor
        
        setTopicsLabelConstraints()
    }
    
    func setTopicsLabelConstraints() {
        topicsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topicsLabel.leadingAnchor.constraint(equalTo: topicsScrollView.leadingAnchor),
            topicsLabel.topAnchor.constraint(equalTo: topicsScrollView.topAnchor),
            topicsLabel.trailingAnchor.constraint(equalTo: topicsScrollView.trailingAnchor),
            topicsLabel.bottomAnchor.constraint(equalTo: topicsScrollView.bottomAnchor),
            topicsLabel.heightAnchor.constraint(equalTo: topicsScrollView.heightAnchor)])
    }
    
    //MARK: - Topic Mark Label
    func setUpTopicMarkLabel() {
        topicMarkLabel.text = Constants.String.topics
        topicMarkLabel.backgroundColor = Constants.Color.topicLabelBackgroundColor
        topicMarkLabel.font = UIFont(name: Constants.FontName.PretendardBold, size: 10)
        topicMarkLabel.textColor = Constants.Color.basicBlueFontColor
        topicMarkLabel.clipsToBounds = true
        topicMarkLabel.layer.cornerRadius = 3
        topicMarkLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Topics Container StackView
    func setUpTopicsContainerStackView() {
        _ = [topicMarkLabel, topicsScrollView].map { self.topicsContainerStackView.addArrangedSubview($0) }
        topicsContainerStackView.axis = .horizontal
        topicsContainerStackView.spacing = 2
        topicsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Vertical StackView
    func setUpVerticalStackView() {
        _ = [repoNameLabel, repoDescriptionLabel, topicsContainerStackView, addtionalRepoInfoScrollView].map { self.verticalStackView.addArrangedSubview($0) }
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        
        setVerticalStackViewConstraints()
    }
    func setVerticalStackViewConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: repoIconImageView.trailingAnchor, constant: 5),
            verticalStackView.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -10),
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func removeTopicsContainerStackView() {
        topicsContainerStackView.isHidden = true
    }
    
    //MARK: - Star Button
    func setUpStarButton() {
        starButton.addTarget(self, action: #selector(starButtonDidTapped), for: .touchUpInside)
        bindStarButton()
        setStarButtonConstraints()
    }
    
    func setStarButtonConstraints() {
        starButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            starButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            starButton.heightAnchor.constraint(equalToConstant: 20),
            starButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func bindStarButton() {
        if KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) != nil {
            NetworkManager.shared.getIsStarred(owner: repositoriesTableViewCellViewModel.getOwner(),
                                               repo: repositoriesTableViewCellViewModel.getName())
            .subscribe(onNext: { [unowned self] isStarred in
                if isStarred {
                    self.starButton.setImage(Constants.Image.starFilled, for: .normal)
                    self.starButton.tintColor = Constants.Color.starOnColor
                }
                else {
                    self.starButton.setImage(Constants.Image.star, for: .normal)
                    self.starButton.tintColor = Constants.Color.starOffColor
                }
            })
            .disposed(by: disposeBag)
        }
        else {
            self.starButton.setImage(Constants.Image.star, for: .normal)
            self.starButton.tintColor = Constants.Color.starOffColor
        }
    }
    
    //MARK: - Addtional Info ScrollView
    func setUpAdditionalRepoInfoScrollView() {
        addtionalRepoInfoScrollView.isScrollEnabled = true
        addtionalRepoInfoScrollView.addSubview(addtionalRepoInfoStackView)
        addtionalRepoInfoScrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - Addtional Info StackView
    func setUpAdditionalRepoInfoStackView() {
        addtionalRepoInfoStackView.axis = .horizontal
        addtionalRepoInfoStackView.spacing = 8
        addtionalRepoInfoStackView.alignment = .top
        
        setAddtionalInfoStackViewConstraints()
    }
    
    func setAddtionalInfoStackViewConstraints() {
        addtionalRepoInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addtionalRepoInfoStackView.leadingAnchor.constraint(equalTo: addtionalRepoInfoScrollView.leadingAnchor),
            addtionalRepoInfoStackView.topAnchor.constraint(equalTo: addtionalRepoInfoScrollView.topAnchor),
            addtionalRepoInfoStackView.trailingAnchor.constraint(equalTo: addtionalRepoInfoScrollView.trailingAnchor),
            addtionalRepoInfoStackView.bottomAnchor.constraint(equalTo: addtionalRepoInfoScrollView.bottomAnchor),
            addtionalRepoInfoStackView.heightAnchor.constraint(equalTo: addtionalRepoInfoScrollView.heightAnchor)])
    }
    
    func updateAdditionalRepoInfoStackView(stargrazerCount: Int, language: String?, license: String?, updatedAt: String) {
        //MARK: - Star ImageView
        starImageView.image = Constants.Image.starFilled
        starImageView.tintColor = Constants.Color.addtionalRepoInfoFontColor
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.heightAnchor.constraint(equalToConstant: 11).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        addtionalRepoInfoStackView.addArrangedSubview(starImageView)
        
        //MARK: - Stargrazer Count Label
        stargrazerCountLabel.text = String(stargrazerCount)
        stargrazerCountLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 10)
        stargrazerCountLabel.textColor = Constants.Color.addtionalRepoInfoFontColor
        stargrazerCountLabel.sizeToFit()
        addtionalRepoInfoStackView.addArrangedSubview(stargrazerCountLabel)
        
        //MARK: - Language Label
        if let language = language {
            languageLabel.text = language
            languageLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 10)
            languageLabel.textColor = Constants.Color.addtionalRepoInfoFontColor
            languageLabel.sizeToFit()
            addtionalRepoInfoStackView.addArrangedSubview(languageLabel)
        } else {
            addtionalRepoInfoStackView.removeArrangedSubview(languageLabel)
            languageLabel.removeFromSuperview()
        }
        
        //MARK: - License Label
        if let license = license {
            licenseLabel.text = license
            licenseLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 10)
            licenseLabel.textColor = Constants.Color.addtionalRepoInfoFontColor
            licenseLabel.sizeToFit()
            addtionalRepoInfoStackView.addArrangedSubview(licenseLabel)
        } else {
            addtionalRepoInfoStackView.removeArrangedSubview(licenseLabel)
            licenseLabel.removeFromSuperview()
        }
        
        //MARK: - UpdatedAt Label
        updatedAtLabel.text = "\(Constants.String.updatedOn) \(DateManager.updatedDateString(dateString: updatedAt) ?? "")"
        updatedAtLabel.font = UIFont(name: Constants.FontName.PretendardRegular, size: 10)
        updatedAtLabel.textColor = Constants.Color.addtionalRepoInfoFontColor
        updatedAtLabel.sizeToFit()
        addtionalRepoInfoStackView.addArrangedSubview(updatedAtLabel)
        
        addtionalRepoInfoStackView.setCustomSpacing(3, after: starImageView)
    }
}

//MARK: - Actions
extension RepositoriesTableViewCell {
    @objc func starButtonDidTapped(sender: UIButton!) {
        if KeychainWrapper.standard.string(forKey: Constants.Keychain.accessToken) != nil {
            NetworkManager.shared.getIsStarred(owner: repositoriesTableViewCellViewModel.getOwner(),
                                               repo: repositoriesTableViewCellViewModel.getName())
            .subscribe(onNext: { [unowned self] isStarred in
                if isStarred {
                    NetworkManager.shared.deleteStarring(owner: self.repositoriesTableViewCellViewModel.getOwner(),
                                                      repo: self.repositoriesTableViewCellViewModel.getName())
                    .subscribe(onNext: { [unowned self] isSuccess in
                        if isSuccess {
                            self.starButton.setImage(Constants.Image.star, for: .normal)
                            self.starButton.tintColor = Constants.Color.starOffColor
                            guard let oldStragrazerCount = Int(self.stargrazerCountLabel.text ?? "") else { return }
                            self.stargrazerCountLabel.text = String(oldStragrazerCount-1)
                        }
                    })
                    .disposed(by: disposeBag)
                }
                else {
                    NetworkManager.shared.putStarring(owner: self.repositoriesTableViewCellViewModel.getOwner(),
                                                         repo: self.repositoriesTableViewCellViewModel.getName())
                    .subscribe(onNext: { [unowned self] isSuccess in
                        if isSuccess {
                            self.starButton.setImage(Constants.Image.starFilled, for: .normal)
                            self.starButton.tintColor = Constants.Color.starOnColor
                            guard let oldStragrazerCount = Int(self.stargrazerCountLabel.text ?? "") else { return }
                            self.stargrazerCountLabel.text = String(oldStragrazerCount+1)
                        }
                    })
                    .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        }
    }
}

//MARK: - Data Update Functions
extension RepositoriesTableViewCell {
    func updateTopicsLabel(topics: String) {
        topicsLabel.text = topics
    }
    
    func updateRepoNameLabel(repoName: String) {
        repoNameLabel.text = repoName
    }
    
    func updateRepoDescriptionLabel(repoDescription: String) {
        repoDescriptionLabel.text = repoDescription
    }
    
    func updaterepositoriesTableViewCellViewModel(name: String, owner: String) {
        repositoriesTableViewCellViewModel.updateProperties(name: name, owner: owner)
    }
}

//MARK: - for Topic Mark Label
class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
