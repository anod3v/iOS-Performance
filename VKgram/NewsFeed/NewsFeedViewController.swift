//
//  NewsFeedViewController.swift
//  VKgram
//
//  Created by Andrey on 20/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import PromiseKit

class NewsFeedViewController: UIViewController, NewsFeedTableViewCellDelegate {
    
    var networkService = NetworkService()
    
//    var newFeedItems = [Item]()
    
    var newsFeedGroups = [Group]()
    
    var newsFeedProfiles = [Profile]()
    
    var photos = [String]()
    
    var profilesOfGroups = [ProfileInterface]()
    
    var profilesAndItems = [(profile: ProfileInterface?, newsItem: Item)]()
    
    var cellHeight: CGFloat = 0
    
    var cell = UITableViewCell()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        return refreshControl
    }()
    
    let cellID = "NewsFeedTableViewCell"
    
    let headerID = "NewsFeedCollectionViewHeader"
    
    var nextFrom = ""
    
    var isLoading = false
    
    var currentIndexPathRow: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.getNewsFeedItems()?.done { result in
            self.handleGetNewsFeedResponse(item: result.0.response, profile: result.1.response, group: result.2.response)
        }
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(NewsFeedTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.pin(to: view)

    }
    
    @objc func refreshNews() {
        
        self.refreshControl.beginRefreshing()
        networkService.getNewsFeedItems()?.done { result in
            self.handleGetNewsFeedResponse(item: result.0.response, profile: result.1.response, group: result.2.response)
        }
    }
    
    
    
    func handleGetNewsFeedResponse(item: ItemResponse, profile: ProfileResponse, group: GroupResponse) {
        let items = item.items
        let profiles = profile.profiles
        let groups = group.groups
        self.nextFrom = item.nextFrom
        
        var profilesOrGroups = [ProfileInterface]()
        
//        let item = newFeedItems[indexPath.row]
        for item in items {
        
        if item.sourceID! >= 0 {
            profilesOrGroups = profiles
        } else {
            profilesOrGroups = groups
        }
        
        let positiveSourceId = item.sourceID! >= 0 ? item.sourceID : (item.sourceID! * -1)
        
        let profileDataToDisplay = profilesOrGroups.first(where: {$0.id == positiveSourceId })
            
        let newElement = (profile: profileDataToDisplay, newsItem: item)
            
            if let photos = item.attachments?.compactMap({$0?.postPhoto}) {
                cachePhotoImages(urls: photos)
            }
        
        profilesAndItems.append(newElement)
            
        }
        
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func cachePhotoImages(urls: [String]) {
        for url in urls {
            PhotoService.shared.photo(url: url) { image in
                // images saved in photoService cache
            }
        }
    }
    
//    func handleGetNewsFeedNextResponse(item: ItemResponse, profile: ProfileResponse, group: GroupResponse) {
//        self.newFeedItems.append(contentsOf: item.items)
//        self.newsFeedProfiles.append(contentsOf: profile.profiles)
//        self.newsFeedGroups.append(contentsOf: group.groups)
//        self.nextFrom = item.nextFrom
//
//        DispatchQueue.main.async { self.tableView.reloadData() }
//    }
    
    func revealPost(for cell: NewsFeedTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension NewsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilesAndItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsFeedTableViewCell
        
        cell.delegate = self
        
        let item = profilesAndItems[indexPath.row]
        
//        if item.sourceID! >= 0 {
//            profilesOfGroups = newsFeedProfiles
//        } else {
//            profilesOfGroups = newsFeedGroups
//        }
//
//        let positiveSourceId = item.sourceID! >= 0 ? item.sourceID : (item.sourceID! * -1)
//
//        let dataToDisplay = profilesOfGroups.first(where: {$0.id == positiveSourceId })
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.configure(item: item.newsItem)
        cell.configureProfile(photo: item.profile?.photo, name: item.profile?.name)
        cell.photoCollageView.isUserInteractionEnabled = false
        
//        currentIndexPathRow = indexPath.row
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToVC(_:)))
//        cell.photoCollageView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard !isLoading else { return }
//        
//        if indexPath.row == newFeedItems.count - 1 {
//            let lastIndex = indexPath.row
//            isLoading = true
//            firstly {
//                networkService.getNewsFeedItemsWithStartTime(startFrom: nextFrom)!
//            }.done { (result) in
//                
//                self.handleGetNewsFeedNextResponse(item: result.0.response, profile: result.1.response, group: result.2.response)
//                
//                let indexPaths = self.makeIndexSet(lastIndex: lastIndex, result.0.response.items.count)
//                tableView.insertRows(at: indexPaths, with: .automatic)
//                self.isLoading = false
//            }.catch { (error) in
//                debugPrint(error.localizedDescription)
//                self.isLoading = false
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cell.bounds.size.height
    }
    
    private func makeIndexSet(lastIndex: Int, _ newsCount: Int) -> [IndexPath] {
        let last = lastIndex + newsCount
        let indexPaths = Array(lastIndex + 1...last).map { IndexPath(row: $0, section: 0) }
        
        return indexPaths
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postFullSizeViewController = PostFullSizeViewController()
        let item = profilesAndItems[indexPath.row].newsItem
        let likes = String(describing: item.likes?.count)
        let text = item.text!
        guard let photos = item.attachments?.compactMap({$0?.postPhoto}) else { return }
        for photo in photos {
            let photoRepresentable = PhotoRepresentable(photo: photo, likes: likes, text: text)
            postFullSizeViewController.photos?.append(photoRepresentable)
        }
            postFullSizeViewController.selectedPostIndex = 0
        
        self.show(postFullSizeViewController, sender: nil)
    }
    
}

extension NewsFeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {

        guard indexPath.row == profilesAndItems.count - 1 else { return }
        
        guard !isLoading else { return }
        
//        if indexPath.row == newFeedItems.count - 1 {
            let lastIndex = indexPath.row
            isLoading = true
            firstly {
                networkService.getNewsFeedItemsWithStartTime(startFrom: nextFrom)!
            }.done { (result) in
                
                self.handleGetNewsFeedResponse(item: result.0.response, profile: result.1.response, group: result.2.response)
                
                let indexPaths = self.makeIndexSet(lastIndex: lastIndex, result.0.response.items.count)
                tableView.insertRows(at: indexPaths, with: .automatic)
                self.isLoading = false
            }.catch { (error) in
                debugPrint(error.localizedDescription)
                self.isLoading = false
            }
//        }
    }
}
}
