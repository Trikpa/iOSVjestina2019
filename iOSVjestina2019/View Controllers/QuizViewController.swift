//
//  ViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 30/04/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var mainContainer: UIScrollView!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var errorMsgPlaceholder: UIView!
    
    @IBOutlet weak var funFactContainer: UIView!
    @IBOutlet weak var funFactLabel: UILabel!
    
    @IBOutlet weak var quizContainerTable: UITableView!
    
    var quizzes: [Quiz] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, self.backgroundGradientView)
    }
    
    @IBAction func GetQuiz(_ sender: Any) {
        getData()
    }
    
    @IBAction func GenerateFunFact(_ sender: UIButton) {
        var numberOfQsContainingWord: Int = 0
        self.quizzes.forEach { (q: Quiz) in
            q.questions.forEach { (qst: Question) in
                if (qst.question.contains("NBA")) {
                    numberOfQsContainingWord += 1
                }
            }
        }
        DispatchQueue.main.async {
            self.funFactLabel.text = "There are \(numberOfQsContainingWord) questions containing the word \"NBA\""
        }
        
    }
    
    fileprivate func getData() {
        if (self.quizzes.count != 0) {
            self.quizzes.removeAll()
        }
        
        self.errorMsgPlaceholder.isHidden = true
        
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
                
                let quiz = try? JSONDecoder().decode(Quizzes.self, from: data)

                for q in quiz!.quizzes {
                    self.quizzes.append(q)
                }
                
                DispatchQueue.main.async {
                    self.funFactContainer.isHidden = false
                    self.quizContainerTable.reloadData()
                }
                
            } else {
                self.errorMsgPlaceholder.isHidden = false
            }
            
        }.resume()
    }
}

extension QuizViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quiz = quizzes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell") as! QuizCell
        
        cell.setQuiz(quiz: quiz)
        
        return cell
    }
}
