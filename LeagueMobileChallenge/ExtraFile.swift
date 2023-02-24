////
////  ExtraFile.swift
////  LeagueMobileChallenge
////
////  Created by Gurpreet Kaur on 23/02/23.
////  Copyright © 2023 Kelvin Lau. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//struct ModelA: Decodable {
//    let id: Int
//    let name: String
//}
//
//struct ModelB: Decodable {
//    let id: Int
//    let description: String
//}
//
//struct MergedModel {
//    let id: Int
//    let name: String
//    let description: String
//}
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    var mergedModels: [MergedModel] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Make API requests to get ModelA and ModelB data
//        // Here's an example using URLSession and Codable
//        
//        let urlA = URL(string: "https://api.example.com/modelA")!
//        let taskA = URLSession.shared.dataTask(with: urlA) { data, response, error in
//            guard let data = data else { return }
//            let decoder = JSONDecoder()
//            do {
//                let modelAData = try decoder.decode([ModelA].self, from: data)
//                
//                let urlB = URL(string: "https://api.example.com/modelB")!
//                let taskB = URLSession.shared.dataTask(with: urlB) { data, response, error in
//                    guard let data = data else { return }
//                    do {
//                        let modelBData = try decoder.decode([ModelB].self, from: data)
//                        
//                        // Merge ModelA and ModelB data into MergedModel
//                        for modelA in modelAData {
//                            if let modelB = modelBData.first(where: { $0.id == modelA.id }) {
//                                let mergedModel = MergedModel(id: modelA.id, name: modelA.name, description: modelB.description)
//                                self.mergedModels.append(mergedModel)
//                            }
//                        }
//                        
//                        // Reload table view on main thread
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//                taskB.resume()
//                
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        taskA.resume()
//        
//        // Set up table view
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//    }
//    
//    // MARK: - Table view data source
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mergedModels.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let mergedModel = mergedModels[indexPath.row]
//        cell.textLabel?.text = "\(mergedModel.name) - \(mergedModel.description)"
//        return cell
//    }
//    
//}
//
//
//
//In this example, we have three models: ModelA, ModelB, and MergedModel. We make API requests to get data for ModelA and ModelB, and then merge the data into MergedModel. We store the merged models in an array called mergedModels, which we use to populate a table view. The table view has one section and the number of rows is equal to the count of mergedModels. We dequeue a cell with identifier "Cell" and set the text label to display the merged model's name and description.
