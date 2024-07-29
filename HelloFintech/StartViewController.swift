//
//  StartViewController.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/23.
//

import UIKit

class StartViewController: UIViewController {
    
    lazy private var emptyButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(title: "", handler: { [weak self] _ in
            let friendListViewController = FriendListViewController(endPoint: .empty)
            self?.navigationController?.pushViewController(friendListViewController, animated: true)
        }))
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .leading
        config.title = "無好友"
        config.baseForegroundColor = .label
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "emptyButton"
        return button
    }()
    
    lazy private var onlyFriendButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(title: "", handler: { [weak self] _ in
            let friendListViewController = FriendListViewController(endPoint: .onlyFriends)
            self?.navigationController?.pushViewController(friendListViewController, animated: true)
        }))
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .leading
        config.title = "只有好友"
        config.baseForegroundColor = .label
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "onlyFriendButton"
        return button
    }()
    
    lazy private var fullButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(title: "", handler: { [weak self] _ in
            let friendListViewController = FriendListViewController(endPoint: .fullFriends)
            self?.navigationController?.pushViewController(friendListViewController, animated: true)
        }))
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .leading
        config.title = "好友含邀請"
        config.baseForegroundColor = .label
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "fullButton"
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(emptyButton)
        self.view.addSubview(onlyFriendButton)
        self.view.addSubview(fullButton)
        
        NSLayoutConstraint.activate([
            emptyButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 44),
            emptyButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            emptyButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            emptyButton.heightAnchor.constraint(equalToConstant: 44),
            
            onlyFriendButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            onlyFriendButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            onlyFriendButton.heightAnchor.constraint(equalToConstant: 44),
            onlyFriendButton.topAnchor.constraint(equalTo: emptyButton.bottomAnchor, constant: 12),
            
            fullButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            fullButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            fullButton.heightAnchor.constraint(equalToConstant: 44),
            fullButton.topAnchor.constraint(equalTo: onlyFriendButton.bottomAnchor, constant: 12),
        ])
    }
}
