//
//  FriendListViewCell.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import UIKit

class FriendListViewCell: UITableViewCell {
    
    static var reuseIdentifier : String {
        String(describing: self)
    }
    
    lazy private var friendListCellAvatarImageView: FriendListAvatarImageView = {
        let imageView = FriendListAvatarImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var friendListAvatarCellStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    lazy private var friendListCellAvatarNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var friendListCellButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .leading
        config.imagePlacement = .trailing
        config.imagePadding = 8.0
        config.baseForegroundColor = .systemPurple
        config.background.backgroundColor = .clear
        config.background.strokeColor = .systemPurple
        config.background.strokeWidth = 4.0
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var friendListCellButton2: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "ellipsis",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .systemGray
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    lazy private var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = .separator
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        return bottomLine
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
        self.setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.contentView.addSubview(friendListCellAvatarImageView)
        self.contentView.addSubview(friendListAvatarCellStarImageView)
        self.contentView.addSubview(friendListCellAvatarNameLabel)
        self.contentView.addSubview(friendListCellButton)
        self.contentView.addSubview(friendListCellButton2)
        self.contentView.addSubview(bottomLine)
    }
   
    func setupAutoLayout() {
        
        NSLayoutConstraint.activate([

            friendListAvatarCellStarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            friendListAvatarCellStarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            friendListAvatarCellStarImageView.heightAnchor.constraint(equalToConstant: 16),
            friendListAvatarCellStarImageView.widthAnchor.constraint(equalToConstant: 16),
            
            friendListCellAvatarImageView.leadingAnchor.constraint(equalTo: friendListAvatarCellStarImageView.trailingAnchor),
            friendListCellAvatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            friendListCellAvatarImageView.heightAnchor.constraint(equalToConstant: 44),
            friendListCellAvatarImageView.widthAnchor.constraint(equalToConstant: 44),
            
            friendListCellAvatarNameLabel.leadingAnchor.constraint(equalTo: friendListCellAvatarImageView.trailingAnchor, constant: 5),
            friendListCellAvatarNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            friendListCellAvatarNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -24),
            
            friendListCellButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            friendListCellButton2.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            bottomLine.leadingAnchor.constraint(equalTo: friendListCellAvatarNameLabel.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            bottomLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -1),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
        ])
       
        friendListCellButton.updateConfiguration()
    }
    
    func configureCell(_ friendModel: FriendModel) {
        friendListCellAvatarNameLabel.text = friendModel.name
        friendListAvatarCellStarImageView.isHidden = friendModel.isTop == "0"
        
        let layout = friendListCellButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        let layout2 = friendListCellButton.trailingAnchor.constraint(equalTo: friendListCellButton2.leadingAnchor, constant: -12)
        let layout3 = friendListCellButton2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            
        layout.isActive = false
        layout2.isActive = true
        layout3.isActive = true
        friendListCellButton2.isHidden = false
        
        let handler: UIButton.ConfigurationUpdateHandler = { [weak self] button in
            
            var attText = AttributedString.init("轉帳")
            attText.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            
            switch friendModel.status {
                case .invited:
                    attText = AttributedString.init("邀請已送出")
                    button.configuration?.attributedTitle = attText
                    button.configuration?.baseForegroundColor = .systemGray
                    button.configuration?.background.backgroundColor = .clear
                    button.configuration?.background.strokeColor = .systemGray
                    button.configuration?.background.strokeWidth = 4.0
                    layout.isActive = true
                    layout2.isActive = false
                    layout3.isActive = false
                    self?.friendListCellButton2.isHidden = true
                
                case .finished:
                    break
                case .inviting:
                    break
            }
            
            attText.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            button.configuration?.attributedTitle = attText
            
            var buttonSize = CGSize.zero
            if let title = self?.friendListCellButton.configuration?.title, let padding = self?.friendListCellButton.configuration?.contentInsets.leading {
                buttonSize = title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0, weight: .regular)])
                buttonSize = CGSize(width: buttonSize.width + (padding * 2), height: buttonSize.height)
            }
            
            self?.friendListCellButton.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true
        }
        
       
 
        friendListCellButton.configurationUpdateHandler = handler
        

    }
}
