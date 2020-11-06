//
//  NewsFeedViewController.swift
//  VKgram
//
//  Created by Andrey on 20/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, NewsFeedTableViewCellDelegate {
    
    var networkService = NetworkService()
    
    var newFeedItems = [Item]()
    
    var newsFeedGroups = [Group]()
    
    var newsFeedProfiles = [Profile]()
    
    var photos = [String]()
    
    var profilesOfGroups = [ProfileInterface]()
    
    var cellHeight: CGFloat = 0
    
    var cell = UITableViewCell()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cellID = "NewsFeedTableViewCell"
    
    let headerID = "NewsFeedCollectionViewHeader"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = networkService.getNewsFeedItems( callback: { // TODO: to check with swiftbook how they optimized this request
            [weak self] (result, error) in
//            debugPrint("the result is:", result)
            self!.handleGetNewsFeedResponse(response: ((result?.response)!))
        })
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.pin(to: view)
    }
    
    func handleGetNewsFeedResponse(response: Response) {
        self.newFeedItems = response.items
        self.newsFeedGroups = response.groups
        self.newsFeedProfiles = response.profiles
        
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func revealPost(for cell: NewsFeedTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newFeedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsFeedTableViewCell
        
        cell.delegate = self
        
        let item = newFeedItems[indexPath.row]
        
        if item.sourceID! >= 0 {
            profilesOfGroups = newsFeedProfiles
        } else {
            profilesOfGroups = newsFeedGroups
        }
        
        let positiveSourceId = item.sourceID! >= 0 ? item.sourceID : (item.sourceID! * -1)
        
        let dataToDisplay = profilesOfGroups.first(where: {$0.id == positiveSourceId })
        
        cell.configure(item: item)
        cell.configureProfile(photo: dataToDisplay!.photo, name: dataToDisplay!.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cell.bounds.size.height
    }
    
    
}
