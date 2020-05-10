//
//  Question.swift
//  iOSVjestina2019
//
//  Created by Five on 01/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation

struct Question : Decodable {
    var id:             Int
    var question:       String
    var answers:        [String]
    var correct_answer: Int
}
