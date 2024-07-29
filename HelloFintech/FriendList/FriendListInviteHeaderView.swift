//
//  FriendListInviteHeaderView.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/26.
//

import UIKit

class FriendListInviteHeaderView: UITableViewHeaderFooterView {

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

    lazy var collapseButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .clear
        config.image = UIImage(systemName: "arrowtriangle.up.fill",
          withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        config.baseForegroundColor = .systemPurple
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left;
        return button
    }()
    
    func commonInit() {
        self.addSubview(collapseButton)
    }
   
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            collapseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            collapseButton.topAnchor.constraint(equalTo: self.topAnchor),
            collapseButton.heightAnchor.constraint(equalToConstant: 26),
            collapseButton.widthAnchor.constraint(equalToConstant: 26),
        ])
        
    }
   
    func configureButton(_ isExpand: Bool) {
        
        let buttonName = isExpand ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
        
       
        collapseButton.imageView?.image = UIImage(systemName: buttonName,
                                                        withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    }
}
