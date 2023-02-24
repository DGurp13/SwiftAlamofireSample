//
//  Posts.swift
//  LeagueMobileChallenge
//
//  Created by Gurpreet Kaur on 21/02/23.
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation

//struct Posts: Decodable  {
//    var username: String?
//
//    enum CodingKeys: String, CodingKey {
//        case username = "username"
//    }
//}


struct Posts: Codable  {
    let id: Int
    let title: String
    let body: String
    
}
