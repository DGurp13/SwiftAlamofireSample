//
//  PostsViewController.swift
//  LeagueMobileChallenge
//
//  Created by Gurpreet Kaur on 21/02/23.
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PostsTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    
    let spinner = UIActivityIndicatorView(style: .gray)
    var postsData = [Posts]()
    var usersData = [Users]()
    var infoMergedData: [Info] = []

    private var isWaiting = false {
        didSet {
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        
        self.errorLabel.isHidden = true
        
        //Table View details
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 200.0
        postsTableView.backgroundView = spinner
        
        //API calling
        self.fetchAPIData()
    }
    
    func fetchAPIData() {
        // Step1: Call login API
        self.isWaiting = true
        APIController.shared.fetchUserToken(userName: "", password: "") { token, error in
            if (token != nil)
            {
                // Step2: Call users API
                let decoder = JSONDecoder()
                APIController.shared.fetchUsers { users, error in
                    if (error == nil) {
                    guard let users = users else { return }
                    do {
                        let usersModel = try decoder.decode([Users].self, from: users as! Data)
                        self.usersData.append(contentsOf: usersModel)
                        // Step2: Call posts API
                        APIController.shared.fetchPosts { posts, error in
                            if (error == nil) {
                                do {
                                    let postsModel = try decoder.decode([Posts].self, from: posts as! Data)
                                    self.postsData.append(contentsOf: postsModel)
                                    
                                    // Merge Users and Posts data into Info
                                    for usersModel in self.usersData {
                                        if let postsModel = self.postsData.first(where: { $0.id == usersModel.id }) {
                                            let infoModel = Info( id: usersModel.id, username: usersModel.username, avatar: usersModel.avatar, title: postsModel.title, body: postsModel.body)
                                            self.infoMergedData.append(infoModel)
                                        }
                                    }
                                    // Reload table
                                    DispatchQueue.main.async {
                                        self.postsTableView.reloadData()
                                    }
                                } catch {
                                    debugPrint(error.localizedDescription)
                                }
                            } else {
                                self.postsTableView.isHidden = true
                                self.errorLabel.isHidden = false
                            }
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                    } else {
                        self.postsTableView.isHidden = true
                        self.errorLabel.isHidden = false
                    }
                }
            }
        }
        // Step3: Update the UI
        self.isWaiting = false
    }
    
    private func updateUI() {
        if !self.isWaiting {
            self.spinner.startAnimating()
        } else {
            self.spinner.stopAnimating()
        }
    }
    
    
    // Table view delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoMergedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as! PostsTableViewCell
        
        cell.avatarImage.layer.cornerRadius = 20
        cell.avatarImage.layer.masksToBounds = true
        
        let infoModel = infoMergedData[indexPath.row]
        
        cell.username.text = infoModel.username
        cell.title.text = infoModel.title
        cell.descriptionLabel.text = infoModel.body
        cell.avatarImage.sd_setImage(with: URL(string: infoModel.avatar))
        return cell
    }
}

