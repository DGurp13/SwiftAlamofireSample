//
//  PostsViewController.swift
//  LeagueMobileChallenge
//
//  Created by Gurpreet Kaur on 21/02/23.
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

//pick id from both if equal then create third array

class PostsTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var dataArray = [String]()
    var postsData = [Posts]()
    var usersData = [Users]()
    
    private var isWaiting = false {
        didSet {
            self.updateUI()
        }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        let group = DispatchGroup()
        // Step1: Call posts API
        APIController.shared.fetchUserToken(userName: "", password: "") { token, error in
            print(token ?? "")
            if (token != nil)
            {
                self.isWaiting = true
                // Step0: Creating and entering dispatch groups
                 group.enter()
                 group.enter()
                
                // Step1: Call users API
                APIController.shared.fetchUsers { users, error in
                    if (error == nil) {
                        do {
                            let model = try JSONDecoder().decode([Users].self, from: users as! Data)
                            self.usersData.append(contentsOf: model)
                            DispatchQueue.main.async {
                                self.postsTableView.reloadData()
                            }
                            print("model == \(model)")
                        } catch {
                            debugPrint(error)
                        }
                    }
                    group.leave()
                }
                
                    
                    // Step2: Call posts API
                    APIController.shared.fetchPosts { posts, error in
                        if (error == nil) {
                            do {
                                let model = try JSONDecoder().decode([Posts].self, from: posts as! Data)
                                self.postsData.append(contentsOf: model)
                                DispatchQueue.main.async {
                                    self.postsTableView.reloadData()
                                }
                                print("model == \(model)")
                            } catch {
                                debugPrint(error)
                            }
                        }
                        group.leave()
                    }
                }
            }
        
        group.notify(queue: .main, execute: {
          // Step3: Update the UI
          self.isWaiting = false
        })
        }
    
    private func updateUI() {
        if self.isWaiting {
            print("Start animating")
//          self.activityIndicatorView.startAnimating()
        } else {
            print("Stop animating")
//          self.activityIndicatorView.stopAnimating()
        }
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as! PostsTableViewCell
        
        cell.title?.text = usersData[indexPath.row].username
//        cell.username?.text = postsData[indexPath.row].title
        cell.descriptionLabel?.text = "Test3"//usernames[indexPath.row]
        //        cell.avatarImage?.image = UIImage(named: usernames[indexPath.row])
        return cell
    }
    
    
    
    
}
