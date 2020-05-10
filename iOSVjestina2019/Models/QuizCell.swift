//
//  QuizCellTableViewCell.swift
//  iOSVjestina2019
//
//  Created by Five on 10/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

class QuizCell: UITableViewCell {
    
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizDescription: UILabel!
    @IBOutlet weak var quizLevel: UILabel!
    
    func setQuiz(quiz: Quiz) {
        quizImage.image = Repo.getImage(urlString: quiz.image).image
        quizTitle.text = quiz.title
        quizDescription.text = quiz.description
        quizLevel.text = "Level: \(quiz.level)"
    }

}
