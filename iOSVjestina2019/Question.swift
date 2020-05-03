//
//  Question.swift
//  iOSVjestina2019
//
//  Created by Five on 01/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation

struct Question : Decodable {
    var id:            Int
    var question:      String
    var answers:       [String]
    var correctAnswer: Int
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        question = try values.decode(String.self, forKey: .question)
        answers = try values.decode([String].self, forKey: .answers)
        correctAnswer = try values.decode(Int.self, forKey: .correctAnswer)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case question = "question"
        case answers = "answers"
        case correctAnswer = "correct_answer"
    }
}
