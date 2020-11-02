//
//  UserFriendsTableViewController.swift
//  LoginForm
//
//  Created by Andrey on 05/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit


class UserFriendsTableViewController: UIViewController {
    
    private (set) var networkService = NetworkService()
    
    private (set) var storageService = StorageService()
    
    private (set) var friends = [User]()
    
    private (set) var selectedFriend = User(id: Int(), firstName: "", lastName: "", photo_200: "", trackCode: "") // TODO: to find a better way to init?
    
    private (set) var friendsDictionary = [String: [User]]()
    
    private (set) var friendSectionTitles = [String]()
    
    private (set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let tableViewRowHeight: CGFloat = 52
    
    private let cellID = "UserFriendsTableViewCell"
    
    //--------------
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private (set) var filteredFriends: [User] = []
    
    //--------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(UserFriendsTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pin(to: view)
        
        _ = networkService.getUserFriends(userId: Session.shared.userId!) {
            [weak self] (result, error) in
            //            debugPrint("DEBUGPRINT:", result)
            self!.handleGetUserFriendsResponse(friends: (result?.response.items)!)
        }
        
        getFriendsDictionary()
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Friends"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        //        _ = networkService.getUserInfo(userId: 616595796, completion: {
        //            (result, error) in
        //            debugPrint("the result is:", result)
        //        })
        //
        //        _ = networkService.getUserGroups(userId: Session.shared.userId!, completion: {
        //            result in
        //            debugPrint(result)
        //        })
        //
        //        _ = networkService.getUserPhotos(userId: 616595781, completion: {
        //            result in
        //            debugPrint(result)
        //        })
        //
        //
        //        _ = networkService.searchGroups(queryText: "music", completion: {
        //            result in
        //            debugPrint(result)
        //        })
    }
    
    //--------
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = friends.filter { (friend: User) -> Bool in
            return friend.firstName.lowercased().contains(searchText.lowercased()) || friend.lastName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func handleGetUserFriendsResponse(friends: [User]) {
        self.storageService.saveUsers(users: friends)
        self.friends = self.storageService.loadUsers()
        //        debugPrint("users print:", self.friends)
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func getFriendsDictionary() {
        
        var friendsToDisplay = [User]()
        
        friendsDictionary = [String: [User]]()
        
        friendSectionTitles = [String]()
        
        if isFiltering {
            friendsToDisplay = filteredFriends
        } else {
            friendsToDisplay = friends
        }
        
        for friend in friendsToDisplay {
            let friendKey = String(friend.firstName.prefix(1))
            if var friendValues = friendsDictionary[friendKey] {
                friendValues.append(friend)
                friendsDictionary[friendKey] = friendValues
            } else {
                friendsDictionary[friendKey] = [friend]
            }
            friendSectionTitles = [String](friendsDictionary.keys)
            friendSectionTitles = friendSectionTitles.sorted(by: { $0 < $1 })
        }
        
    }
    
}

extension UserFriendsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        getFriendsDictionary()
        return friendSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendKey = friendSectionTitles[section]
        if let friendValues = friendsDictionary[friendKey] {
            return friendValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserFriendsTableViewCell
        
        let friendKey = friendSectionTitles[indexPath.section]
        if let friendValues = friendsDictionary[friendKey] {
            cell.configure(for: friendValues[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserFriendsTableViewCell
        let friendPhotoViewController = FriendPostsViewController()
        friendPhotoViewController.selectedFriend = cell.selectedFriend
        self.show(friendPhotoViewController, sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendSectionTitles
    }
}

extension UserFriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


