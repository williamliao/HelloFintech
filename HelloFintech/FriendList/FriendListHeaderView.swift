//
//  FriendListHeaderView.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/23.
//

import UIKit

class FriendListHeaderView: UITableViewHeaderFooterView {

    static var reuseIdentifier : String {
        String(describing: self)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "FriendListHeaderViewTitleLabel"
        return label
    }()
    
    lazy private var addFriendButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "加好友"
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "plus.circle",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .systemPurple
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    lazy private var collapseButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "arrowtriangle.up.fill",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .systemPurple
        config.contentInsets = .zero
        button.configuration = config
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        searchBar = UISearchBar()
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.autocapitalizationType = .none
        searchBar.backgroundImage = UIImage()
        searchBar.accessibilityIdentifier = "tableHeaderSearchBar"
        searchBar.isAccessibilityElement = true
        return searchBar
    }()
    
    func commonInit() {
        //self.accessibilityIdentifier = "FriendListHeaderView"
        //self.isAccessibilityElement = true

        self.addSubview(titleLabel)
        self.addSubview(addFriendButton)
        self.addSubview(searchBar)
        self.addSubview(collapseButton)
    }
   
    func setupAutoLayout() {
        NSLayoutConstraint.activate([

            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
          //  titleLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -5),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            
            addFriendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            addFriendButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addFriendButton.heightAnchor.constraint(equalToConstant: 16),
            addFriendButton.widthAnchor.constraint(equalToConstant: 80),
            
            collapseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            collapseButton.topAnchor.constraint(equalTo: self.topAnchor),
            collapseButton.heightAnchor.constraint(equalToConstant: 26),
            collapseButton.widthAnchor.constraint(equalToConstant: 26),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ])
        
    }
    
    func configurateHeaderView(_ count: Int) {
        titleLabel.text = "好友列表 \(count)"
    }
}
