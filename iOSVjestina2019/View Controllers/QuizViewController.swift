//
//  QuizViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 21/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

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
	
	var startTime: Date? = nil
	var endTime: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, backgroundGradientView)
		
		startTime = Date.init()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.displayQuestionAndAnswers()
            }
        } else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.showEndGameScreen()
			}
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
		endTime = Date.init()
		clearScreen(view: mainContainer)
		displayQuizStats()
		sendScoreToServer()
    }
	
	fileprivate func clearScreen(view: UIView) {
		lblQuestion.removeFromSuperview()
		quizProgressContainer.removeFromSuperview()
		answerButtonContainer.removeFromSuperview()
		lblQuizProgress.removeFromSuperview()
		
		answerButtonCollection.removeAll()
		progressBarTabs.removeAll()
	}
	
	fileprivate func displayQuizStats() {
		let infoLabel = UILabel()
		infoLabel.numberOfLines = 1
		infoLabel.font = UIFont.systemFont(ofSize: 33)
		infoLabel.textColor = .white
		
		if numOfCorrectAnswers < 4 {
			infoLabel.text = "You can do better! \(numOfCorrectAnswers)/\(quiz?.questions.count ?? 0)"
		} else if numOfCorrectAnswers < 7 {
			infoLabel.text = "Good, but not great. \(numOfCorrectAnswers)/\(quiz?.questions.count ?? 0)"
		} else {
			infoLabel.text = "You're a true genius! \(numOfCorrectAnswers)/\(quiz?.questions.count ?? 0)"
		}

		mainContainer.addSubview(infoLabel)
		
		infoLabel.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor).isActive = true
		infoLabel.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor).isActive = true

		infoLabel.translatesAutoresizingMaskIntoConstraints = false
	}
	
	fileprivate func sendScoreToServer() {
		let elapsedTime: Double = endTime?.timeIntervalSince(startTime ?? Date.init()) ?? -1
		let roundedElapsedTime = Double(round(elapsedTime * 100)/100)
		
		var score = Score()
		score.quiz_id = self.quiz?.id ?? -1
		score.no_of_correct = self.numOfCorrectAnswers
		score.time = roundedElapsedTime
		score.user_id = UserDefaults.standard.integer(forKey: "userID")
		
		do {
			let jsonData = try JSONEncoder().encode(score)
			
			let url = URL(string: "https://iosquiz.herokuapp.com/api/result")!
			
			var request = URLRequest(url: url)
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
			request.httpMethod = "POST"
			request.httpBody = jsonData
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let httpResponse = response as? HTTPURLResponse {
					let enumResponse = ServerResponse(rawValue: httpResponse.statusCode)
					switch enumResponse {
						case .OK:
							DispatchQueue.main.async {
								Repo.displayAlertMessage(vc: self, title: "Success!", message: "Score uploaded successfully")
							}
						default:
							DispatchQueue.main.async {
								Repo.displayAlertMessage(vc: self, title: "Error", message: "Something went wrong when sending score to the server")
							}
					}
				}

			}.resume()
			
		} catch {
			Repo.displayAlertMessage(vc: self, title: "Error", message: "Unable to process data.")
		}
	}
}
