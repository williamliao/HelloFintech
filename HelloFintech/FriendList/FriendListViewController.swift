//
//  FriendListViewController.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import UIKit

enum EndPint {
    case empty
    case onlyFriends
    case fullFriends
}

class FriendListViewController: UIViewController {
    
    var friendListView = FriendListView()
    
    var viewModel: FriendListViewModel!
    
    var endPoint:EndPint = .empty
    
    init(endPoint: EndPint) {
        super.init(nibName: nil, bundle: nil)
        self.endPoint = endPoint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FriendListViewModel(session: URLSession.shared)
        configureNavBar()
        configureView()
        configureBinding()
        configureObserver()
        definesPresentationContext = true
        
        getData()
    }
    
    private func getData() {
        
        Task {

            do {
                
                switch endPoint {
                case .empty:
                    try await viewModel.getData(for: .empty(), using: ())
                case .onlyFriends:
                    try await viewModel.getData2(for: .only(), for: .only2(), using: (), using: ())
                case .fullFriends:
                    try await viewModel.getData(for: .full(), using: ())
                }
                
                
            } catch {
                
            }
        }
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        friendListView.translatesAutoresizingMaskIntoConstraints = false
        friendListView.friendListTableView.dataSource = self
        friendListView.friendListTableView.delegate = self
        friendListView.friendListTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.view.addSubview(friendListView)

        UITableView.appearance().sectionHeaderTopPadding = 0.0;
        
        if #available(iOS 11.0, *) {
            friendListView.friendListTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        NSLayoutConstraint.activate([
            friendListView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            friendListView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            friendListView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            friendListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavBar() {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(systemName: "creditcard"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(atmButtonPress), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)

        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(systemName: "dollarsign.arrow.circlepath"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(dollarsignButtonPress), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn3.addTarget(self, action: #selector(dollarsignButtonPress), for: .touchUpInside)
        let item3 = UIBarButtonItem(customView: btn3)

        self.navigationItem.setLeftBarButtonItems([item1,item2], animated: true)
        self.navigationItem.setRightBarButtonItems([item3], animated: true)
    }
    
    private func configureBinding() {
        viewModel.frinedList.bind { [weak self] (result) in
            
            guard let result = result else {
                return
            }
            
            if (result.count == 0) {
                self?.friendListView.showEmptyView(true)
                return
            }
            
            self?.friendListView.showEmptyView(false)
            self?.friendListView.friendListTableView.reloadData()
        }
        
        viewModel.searchedFrineds.bind { [weak self] (result) in
            guard let result = result else {
                return
            }
            
            if (result.count == 0) {
                return
            }
            
            self?.friendListView.friendListTableView.reloadData()
        }
    }
    
    @objc private func pullToRefresh() {
        
        viewModel.cleanData()
        self.getData()
        friendListView.friendListTableView.refreshControl?.endRefreshing()
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension FriendListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if viewModel.searching {
            
            guard let count = viewModel.searchedFrineds.value?.count else {
                return 0
            }
            
            if !viewModel.isExpand {
                return 0
            }
            
            return count
            
        } else {
            guard let count = viewModel.invitedfrinedList.value?.count, let count2 = viewModel.frinedList.value?.count else {
                return 0
            }
            
            if section == 0 {
                if !viewModel.isExpand {
                    return 0
                } else {
                    return count
                }
                
            } else {
                return count2
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.searching {
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendListViewCell.reuseIdentifier, for: indexPath) as? FriendListViewCell
            guard let friends = viewModel.searchedFrineds.value else {
                return UITableViewCell()
            }
            let model = friends[indexPath.row]
            cell?.configureCell(model)
            return cell ?? UITableViewCell()
        } else {
            if (indexPath.section == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: FriendListInviteViewCell.reuseIdentifier, for: indexPath) as? FriendListInviteViewCell
                guard let friends = viewModel.invitedfrinedList.value else {
                    return UITableViewCell()
                }
                cell?.selectionStyle = .none
                let model = friends[indexPath.row]
                cell?.configureCell(model)
                return cell ?? UITableViewCell()
            } else {
                if viewModel.searching {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: FriendListViewCell.reuseIdentifier, for: indexPath) as? FriendListViewCell
                    
                    guard let friends = viewModel.searchedFrineds.value else {
                        return UITableViewCell()
                    }
                    let model = friends[indexPath.row]
                    cell?.configureCell(model)
                    
                    cell?.selectionStyle = .none
                    return cell ?? UITableViewCell()
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FriendListViewCell.reuseIdentifier, for: indexPath) as? FriendListViewCell
                    
                    guard let friends = viewModel.frinedList.value else {
                        return UITableViewCell()
                    }
                    let model = friends[indexPath.row]
                    cell?.configureCell(model)
                    
                    cell?.selectionStyle = .none
                    return cell ?? UITableViewCell()
                }
            }
        }
    }
}

extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return viewModel.isExpand ? UITableView.automaticDimension : 0.1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView,
                       heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        } else {
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        if viewModel.frinedList.value?.count == 0 {
            return nil
        }
     
        if section == 0 {
            
            guard let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: FriendListInviteHeaderView.reuseIdentifier
            )
                as? FriendListInviteHeaderView
            else {
                return nil
            }
            
            view.configureButton(viewModel.isExpand)
            view.collapseButton.addTarget(self, action: #selector(collapseButtonPress), for: .touchUpInside)
            
            return view
            
        } else if section == 1 {
            
            let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: FriendListHeaderView.reuseIdentifier
            )
                as? FriendListHeaderView
            
            if let count = viewModel.frinedList.value?.count {
                view?.configurateHeaderView(count)
            }
            
            view?.searchBar.delegate = self
            
            return view
        } else {
            return nil
        }
    }
    
    @objc func collapseButtonPress() {
        viewModel.isExpand = !viewModel.isExpand
        
        let indexSet = IndexSet(integer: 0)
        friendListView.friendListTableView.reloadSections(indexSet, with: .automatic)
    }
}

extension FriendListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
        searchBar.text?.trimmingCharacters(in: whitespaceCharacterSet)
            
        guard let searchItems = viewModel.frinedList.value, let searchString = strippedString else {
            return
        }
       
        viewModel.searchedFrineds.value = searchItems.filter {
            return $0.name.uppercased().localizedCaseInsensitiveContains(searchString.uppercased())
        }

        viewModel.searching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searching = false
        searchBar.text = ""
        friendListView.friendListTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searching = false
            searchBar.text = ""
            friendListView.friendListTableView.reloadData()
        }
    }
}

extension FriendListViewController {
    @objc private func handleKeyboardWillShowNotification(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        UIView.performWithoutAnimation {
            friendListView.friendListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.height, right: 0)
            friendListView.friendListTableView.layoutIfNeeded()
            friendListView.friendListTableView.reloadData()
        }
    }
    
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification?) {
        UIView.performWithoutAnimation {
            friendListView.friendListTableView.contentInset = .zero
            friendListView.friendListTableView.layoutIfNeeded()
        }
    }
    
    @objc private func atmButtonPress() {
        
    }
    
    @objc private func dollarsignButtonPress() {
        
    }
}
