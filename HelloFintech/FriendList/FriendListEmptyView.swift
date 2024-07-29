//
//  FriendListEmptyView.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/23.
//

import UIKit

class FriendListEmptyView: UIView {

    lazy private var friendListAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.3.fill",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 300))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy private var friendListInviteTitle: UILabel = {
        let label = UILabel()
        label.text = "就從加好友開始吧:)"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var friendListInviteSubTitle: UILabel = {
        let label = UILabel()
        label.text = "與好友們一起用KOKO \n    快速轉帳最方便！"
        label.textAlignment = .left
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var friendListAdddButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "加好友"
        config.imagePlacement = .trailing
        config.background.backgroundColor = .systemGreen
        config.image = UIImage(systemName: "face.smiling.inverse",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .white
        config.contentInsets = .zero
        config.cornerStyle = .capsule
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var friendListSettingIdLabel: UILabel = {
        let label = UILabel()
        label.text = "幫助好友更快速的找到您? 設定 KOKO ID"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.accessibilityIdentifier = "FriendListEmptyView"
        commonInit()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.addSubview(friendListAvatarImageView)
        self.addSubview(friendListInviteTitle)
        self.addSubview(friendListInviteSubTitle)
        self.addSubview(friendListAdddButton)
        self.addSubview(friendListSettingIdLabel)
    }
 
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            friendListAvatarImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            friendListAvatarImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            friendListAvatarImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            friendListAvatarImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            friendListInviteTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            friendListInviteTitle.bottomAnchor.constraint(equalTo: friendListInviteSubTitle.topAnchor, constant: -16),
            
            friendListInviteSubTitle.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            friendListInviteSubTitle.bottomAnchor.constraint(equalTo: friendListAdddButton.topAnchor, constant: -16),
          
            friendListAdddButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            friendListAdddButton.bottomAnchor.constraint(equalTo: friendListSettingIdLabel.topAnchor, constant: -16),
            friendListAdddButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            
            friendListSettingIdLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            friendListSettingIdLabel.topAnchor.constraint(equalTo: friendListAdddButton.bottomAnchor, constant: 16),
            friendListSettingIdLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
        
//        if let width = friendListAvatarImageView.image?.size.width, let height = friendListAvatarImageView.image?.size.height {
//            let aspectRatio = width / height
//            
//            friendListAvatarImageView.widthAnchor.constraint(equalTo: friendListAvatarImageView.heightAnchor, multiplier: aspectRatio).isActive = true
//        }
        
        
        friendListAvatarImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
    }
}
