//
//  Session.swift
//  iOSVjestina2019
//
//  Created by Five on 26/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation

struct Session : Decodable {
    var token: String
    var userID: UInt64
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decode(String.self, forKey: .token)
        userID = try values.decode(UInt64.self, forKey: .user_id)
    }
    
    enum CodingKeys : String, CodingKey {
        case token
        case user_id
    }
}
