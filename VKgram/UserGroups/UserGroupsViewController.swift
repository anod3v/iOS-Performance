//
//  UserGroupsViewController.swift
//
//  Created by Andrey on 05/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit


class UserGroupsViewController: UIViewController {
    
    private (set) var networkService = NetworkService()
    
    private (set) var storageService = StorageService()
    
    private (set) var groups = [GroupItem]()
    
    private (set) var selectedGroup: GroupItem?
    
//    private (set) var groupsDictionary = [String: [Group]]()
    
//    private (set) var groupSectionTitles = [String]()
    
    private (set) var groupHeaderView: UserGroupsHeaderView = {
        let view = UserGroupsHeaderView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let tableViewRowHeight: CGFloat = 40
    
    private let cellID = "UserGroupsTableViewCell"
    
    //--------------
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private (set) var filteredGroups: [GroupItem] = []
    
    private (set) var userInfo: UserInfoResponse?
    
    var groupsToDisplay = [GroupItem]()
    
    //--------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .cyan
        tableView.register(UserGroupsTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = groupHeaderView
        tableView.pin(to: view)
        setupConstraints()
        tableView.tableHeaderView?.layoutIfNeeded()
        
        networkService.getUserGroups(userId: Session.shared.userId!)?
            .done { groups in
                self.handleUserGroupsResponse(groups: groups.response.items)
                print (groups)
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friends"
        setupSearchBarFont()
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    
    //--------
    
    func setupSearchBarFont() {
        let textFieldInsideUISearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = Constants.Fonts.regularOfSize16
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredGroups = groups.filter { (group: GroupItem) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased()) 
        }
        tableView.reloadData()
    }
    
    func handleUserGroupsResponse(groups: [GroupItem]) {
//        self.storageService.saveUsers(users: friends)
//        self.groups = self.storageService.loadUsers()
        //        debugPrint("users print:", self.friends)
        self.groups = groups
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            groupHeaderView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            groupHeaderView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor),
            groupHeaderView.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            groupHeaderView.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
    
    func getGroupsToDisplay() {
        
        if isFiltering {
            groupsToDisplay = filteredGroups
            tableView.tableHeaderView?.removeFromSuperview()
            tableView.tableHeaderView? = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        } else {
            groupsToDisplay = groups
            tableView.tableHeaderView = groupHeaderView
        }
        
    }
    
}

extension UserGroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        getGroupsToDisplay()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserGroupsTableViewCell
        
            cell.configure(for: groupsToDisplay[indexPath.row])

//        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserFriendsTableViewCell
        let friendPhotoViewController = FriendPostsViewController()
        friendPhotoViewController.selectedFriend = cell.selectedFriend
        self.show(friendPhotoViewController, sender: nil)
        
    }

}

extension UserGroupsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


