//
//  FriendListView.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import UIKit

class FriendListAvatarImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = self.bounds.size.width / 2.0
        clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = radius
    }
}

class FriendListView: UIView {
    
    var friendListEmptyView = FriendListEmptyView()
    
    lazy private var friendListAvatarView: UIView = {
       let avatarView = UIView()
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.backgroundColor = .white
       return avatarView
    }()
    
    lazy private var friendListAvatarImageView: FriendListAvatarImageView = {
        let imageView = FriendListAvatarImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var friendListAvatarNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "UserName"
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var friendListUserIdButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "KOKO ID: UserId"
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = 8.0
        config.baseForegroundColor = .label
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "greaterthan",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    lazy var friendListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FriendListViewCell.self, forCellReuseIdentifier: FriendListViewCell.reuseIdentifier)
        tableView.register(FriendListInviteViewCell.self, forCellReuseIdentifier: FriendListInviteViewCell.reuseIdentifier)
        tableView.register(FriendListHeaderView.self, forHeaderFooterViewReuseIdentifier: FriendListHeaderView.reuseIdentifier)
        tableView.register(FriendListInviteHeaderView.self, forHeaderFooterViewReuseIdentifier: FriendListInviteHeaderView.reuseIdentifier)
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = UITableView.automaticDimension
        tableView.accessibilityIdentifier = "tableView"
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.accessibilityIdentifier = "FriendListView"
        friendListEmptyView.isHidden = true
        commonInit()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        friendListTableView.refreshControl = UIRefreshControl()
        
        self.backgroundColor = .systemGray6
        self.addSubview(friendListAvatarView)
        friendListAvatarView.addSubview(friendListAvatarImageView)
        friendListAvatarView.addSubview(friendListAvatarNameLabel)
        friendListAvatarView.addSubview(friendListUserIdButton)
        self.addSubview(friendListTableView)
    }
 
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            friendListAvatarView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            friendListAvatarView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            friendListAvatarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),

            friendListAvatarImageView.trailingAnchor.constraint(equalTo: friendListAvatarView.trailingAnchor, constant: -16),
            friendListAvatarImageView.widthAnchor.constraint(equalToConstant: 32),
            friendListAvatarImageView.heightAnchor.constraint(equalToConstant: 32),
            friendListAvatarImageView.topAnchor.constraint(equalTo: friendListAvatarView.topAnchor, constant: 5),
            
            friendListAvatarNameLabel.topAnchor.constraint(equalTo: friendListAvatarView.topAnchor, constant: 5),
            friendListAvatarNameLabel.leadingAnchor.constraint(equalTo: friendListAvatarView.leadingAnchor,  constant: 20),
            friendListAvatarNameLabel.trailingAnchor.constraint(equalTo: friendListAvatarImageView.leadingAnchor,  constant: -5),
            
            friendListUserIdButton.topAnchor.constraint(equalTo: friendListAvatarNameLabel.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            friendListUserIdButton.leadingAnchor.constraint(equalTo: friendListAvatarView.leadingAnchor,  constant: 20),
            friendListUserIdButton.trailingAnchor.constraint(equalTo: friendListAvatarNameLabel.trailingAnchor),
            friendListUserIdButton.bottomAnchor.constraint(equalTo: friendListAvatarView.bottomAnchor, constant: -5),
            
            friendListTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            friendListTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            friendListTableView.topAnchor.constraint(equalTo: friendListAvatarView.bottomAnchor, constant: 12),
            friendListTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        friendListEmptyView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendListEmptyView)
        NSLayoutConstraint.activate([
            friendListEmptyView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            friendListEmptyView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            friendListEmptyView.topAnchor.constraint(equalTo: friendListAvatarView.bottomAnchor, constant: 12),
            friendListEmptyView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func showEmptyView(_ show: Bool) {
        friendListTableView.isHidden = show
        friendListEmptyView.isHidden = !show
    }
}

extension UIImageView {
    
    func makeRounded() {
        
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
