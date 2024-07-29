//
//  FriendListInviteViewCell.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/23.
//

import UIKit

class FriendListInviteViewCell: UITableViewCell {
    
    static var reuseIdentifier : String {
        String(describing: self)
    }
    
    lazy private var friendListCellContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    lazy private var friendListCellAvatarImageView: FriendListAvatarImageView = {
        let imageView = FriendListAvatarImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy private var friendListInviteCellAvatarNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var friendListInviteCellSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "邀請您成為好友:)"
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var friendListInviteCellAgreeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "checkmark.circle",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .systemPurple
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    lazy private var friendListInviteCellDenyButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "xmark.circle",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .systemGray
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.setupAutoLayout()
        
        // add shadow on cell
        backgroundColor = .clear // very important
        friendListCellContentView.layer.masksToBounds = false
        friendListCellContentView.layer.shadowOpacity = 0.23
        friendListCellContentView.layer.shadowRadius = 4
        friendListCellContentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        friendListCellContentView.layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        friendListCellContentView.backgroundColor = .white
        friendListCellContentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        self.contentView.addSubview(friendListCellContentView)
        friendListCellContentView.addSubview(friendListCellAvatarImageView)
        friendListCellContentView.addSubview(friendListInviteCellAvatarNameLabel)
        friendListCellContentView.addSubview(friendListInviteCellSubtitleLabel)
        friendListCellContentView.addSubview(friendListInviteCellAgreeButton)
        friendListCellContentView.addSubview(friendListInviteCellDenyButton)
    }
   
    func setupAutoLayout() {

        NSLayoutConstraint.activate([
            
            friendListCellContentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            friendListCellContentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            friendListCellContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            friendListCellContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            friendListCellAvatarImageView.leadingAnchor.constraint(equalTo: friendListCellContentView.leadingAnchor, constant: 10),
            friendListCellAvatarImageView.centerYAnchor.constraint(equalTo: friendListCellContentView.centerYAnchor),
            friendListCellAvatarImageView.heightAnchor.constraint(equalToConstant: 44),
            friendListCellAvatarImageView.widthAnchor.constraint(equalToConstant: 44),
            
            friendListInviteCellAvatarNameLabel.leadingAnchor.constraint(equalTo: friendListCellAvatarImageView.trailingAnchor, constant: 5),
            friendListInviteCellAvatarNameLabel.topAnchor.constraint(equalTo: friendListCellAvatarImageView.topAnchor),
            friendListInviteCellAvatarNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            friendListInviteCellSubtitleLabel.leadingAnchor.constraint(equalTo: friendListInviteCellAvatarNameLabel.leadingAnchor),
            friendListInviteCellSubtitleLabel.topAnchor.constraint(equalTo: friendListInviteCellAvatarNameLabel.bottomAnchor),
            friendListInviteCellSubtitleLabel.trailingAnchor.constraint(equalTo: friendListInviteCellAvatarNameLabel.trailingAnchor),
            friendListInviteCellSubtitleLabel.bottomAnchor.constraint(equalTo: friendListCellContentView.bottomAnchor, constant: -12),
            
            friendListInviteCellAgreeButton.centerYAnchor.constraint(equalTo: friendListCellAvatarImageView.centerYAnchor),
            friendListInviteCellAgreeButton.trailingAnchor.constraint(equalTo: friendListInviteCellDenyButton.leadingAnchor, constant: -5),

            friendListInviteCellDenyButton.centerYAnchor.constraint(equalTo: friendListCellContentView.centerYAnchor),
            friendListInviteCellDenyButton.trailingAnchor.constraint(equalTo: friendListCellContentView.trailingAnchor, constant: -10),
        ])
    }
    
    func configureCell(_ friendModel: FriendModel) {
        friendListInviteCellAvatarNameLabel.text = friendModel.name
    }
}
