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

	@IBOutlet weak var mainContainer: UIView!
	@IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblQuizProgress: UILabel!
    @IBOutlet weak var quizProgressContainer: UIStackView!
    
    @IBOutlet weak var answerButtonContainer: UIStackView!
    
    var quiz: Quiz? = nil
    
    var progressBarTabs: [UIView] = []
    var answerButtonCollection: [UIButton] = []
    
    var currentQuestionIndex: Int = 0
    
    var correctAnswerIndex: Int? = nil
	
	var numOfCorrectAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, backgroundGradientView)
        
        initComponents()
        displayQuestionAndAnswers()
    }
    
    @IBAction func GoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func answerButtonClicked(_ sender: UIButton) {
        updateGameState(pressedButton: sender)
    }
    
    fileprivate func initComponents() {
        displayQuizProgressComponents()
        displayAnswerButtons()
    }
    
    fileprivate func displayQuizProgressComponents() {
        lblQuizProgress.text = "\(currentQuestionIndex + 1)/\(quiz?.questions.count ?? -1)"
        
        if progressBarTabs.count == 0 {
            let n = quiz?.questions.count ?? 0
            
            for _ in 1...n {
                let tab = UIView()
                tab.backgroundColor = .white
                tab.layer.cornerRadius = 5
                
                progressBarTabs.append(tab)
                
                quizProgressContainer.addArrangedSubview(tab)
            }
        }
    }
    
    fileprivate func displayAnswerButtons() {
        let currentQuestion = quiz?.questions[currentQuestionIndex]
        let n = currentQuestion?.answers.count ?? 0
        
        for i in 0..<n {
            let btn = UIButton(type: .system)
            btn.setTitleColor(.systemPink, for: .normal)
            btn.titleLabel?.font = UIFont(name: "System", size: 24)
            
            btn.backgroundColor = .white
            btn.layer.cornerRadius = 45
            
            btn.tag = i
            btn.addTarget(self, action: #selector(answerButtonClicked), for: .touchUpInside)
            
            answerButtonCollection.append(btn)
            
            answerButtonContainer.addArrangedSubview(btn)
        }
    }
    
    fileprivate func updateGameState(pressedButton btn: UIButton) {
        let correctButton = answerButtonCollection[correctAnswerIndex ?? 0]
        
        if btn == correctButton {
			numOfCorrectAnswers += 1
			
            btn.backgroundColor = Repo.correctAnswerColor()
            btn.setTitleColor(.white, for: .normal)
            
            progressBarTabs[currentQuestionIndex].backgroundColor = Repo.correctAnswerColor()
            
            disableButtonPresses()
        } else {
            btn.backgroundColor = Repo.wrongAnswerColor()
            btn.setTitleColor(.white, for: .normal)
            
            progressBarTabs[currentQuestionIndex].backgroundColor = Repo.wrongAnswerColor()
            
            //show the correct answer
            correctButton.backgroundColor = Repo.correctAnswerColor()
            correctButton.setTitleColor(.white, for: .normal)
            
            disableButtonPresses()
        }
        
        if currentQuestionIndex + 1 != quiz?.questions.count ?? 1 - 1 {
            currentQuestionIndex += 1
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.displayQuestionAndAnswers()
            }
        } else {
            showEndGameScreen()
        }
    }
    
    fileprivate func disableButtonPresses() {
        answerButtonCollection.forEach { btn in
            btn.isEnabled = false
        }
    }
    
    fileprivate func displayQuestionAndAnswers() {
        resetButtonColors()
        correctAnswerIndex = quiz?.questions[currentQuestionIndex].correct_answer
        
        let currentQuestion = quiz?.questions[currentQuestionIndex]
        
        lblQuizProgress.text = "\(currentQuestionIndex + 1)/\(quiz?.questions.count ?? -1)"
        lblQuestion.text = currentQuestion?.question
        
        let n = currentQuestion?.answers.count ?? 0
        for i in 0..<n {
            answerButtonCollection[i].setTitle(currentQuestion?.answers[i], for: .normal)
            answerButtonCollection[i].isEnabled = true
        }
    }
	
	fileprivate func resetButtonColors() {
		let n = quiz?.questions[currentQuestionIndex].answers.count ?? 0

		for i in 0..<n {
			self.answerButtonCollection[i].backgroundColor = .white
			self.answerButtonCollection[i].setTitleColor(.systemPink, for: .normal)
		}
	}
	
    fileprivate func showEndGameScreen() {
		clearScreen(view: mainContainer)
		displayQuizStats()
    }
	
	fileprivate func clearScreen(view: UIView) {
		view.subviews.forEach { v in
			switch v {
				case is UIButton:
					break
				case is UIStackView:
					v.removeFromSuperview()
					break
				case is UILabel:
					v.removeFromSuperview()
					break
				default:
					v.removeFromSuperview()
					break
			}
		}
	}
	
	fileprivate func displayQuizStats() {
		
	}
}
