//
//  QuizViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 21/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit
import PureLayout

class QuizViewController: UIViewController {

    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblQuizProgress: UILabel!
    @IBOutlet weak var quizProgressContainer: UIStackView!
    
    @IBOutlet weak var answerButtonContainer: UIStackView!
    
    var quiz: Quiz? = nil
    
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, backgroundGradientView)
        
        initComponents()
    }
    
    @IBAction func GoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func initComponents() {
        lblQuestion.text = quiz?.questions[0].question
        initQuizProgressComponents()
        initAnswerButtons()
    }
    
    fileprivate func initQuizProgressComponents() {
        lblQuizProgress.text = "\(currentQuestionIndex + 1)/\(quiz?.questions.count ?? -1)"
    }
    
    fileprivate func initAnswerButtons() {
        quiz?.questions[currentQuestionIndex].answers.forEach({ a in
            createAnswerButton(answer: a)
        })
    }
    
    fileprivate func createAnswerButton(answer: String) {
        
    }
}
