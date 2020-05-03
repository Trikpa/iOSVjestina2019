//
//  Quiz.swift
//  iOSVjestina2019
//
//  Created by Five on 01/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation

enum Category : String, CaseIterable {
    case SPORTS
    case SCIENCE
    case UNDEFINED
    
    func byName(name: String) -> String {
        return Category.SCIENCE.rawValue
    }
}

struct Quiz : Decodable {
    var id:            Int
    var title:         String
    var description:   String
    var category:      Category
    var level:         Int
    var imageLocation: String
    var questions:     [Question]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        category = try Category(rawValue: (values.decode(String.self, forKey: .category))) ?? Category.UNDEFINED
        level = try values.decode(Int.self, forKey: .level)
        imageLocation = try values.decode(String.self, forKey: .imageLocation)
        questions = try values.decode([Question].self, forKey: .questions)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case category = "category"
        case level = "level"
        case imageLocation = "image"
        case questions = "questions"
    }
}
