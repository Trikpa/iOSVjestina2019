//
//  Score.swift
//  iOSVjestina2019
//
//  Created by Five on 29/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation

struct Score : Codable {
    var quiz_id: Int
    var user_id: Int
    var time: Double
    var no_of_correct: Int
    
    init() {
        quiz_id = -1
        user_id = -1
        time = -1
        no_of_correct = -1
    }
}
