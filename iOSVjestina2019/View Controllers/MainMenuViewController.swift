//
//  ViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 30/04/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var mainContainer: UIScrollView!
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var getQuizButton: UIButton!
    
    @IBOutlet weak var errorMsgPlaceholder: UIView!
    
    @IBOutlet weak var funFactContainer: UIView!
    @IBOutlet weak var funFactLabel: UILabel!
    
    @IBOutlet weak var quizContainerTable: UITableView!
    
    var quizzes: [Quiz] = []
    var quizzesByCategory = [Category: [Quiz]]()
    var sections: Set<Category> = []
    var arrSections: Array<Category> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, self.backgroundGradientView)
    }
    
    @IBAction func GetQuiz(_ sender: Any) {
        getQuizButton.isEnabled = false
        getData()
    }
    
    @IBAction func GenerateFunFact(_ sender: UIButton) {
        var numberOfQsContainingWord: Int = 0
        self.quizzes.forEach { q in
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
                    self.sections.insert(q.category)
                }
                
                self.arrSections = Array(self.sections)
                self.arrSections.sort { (c1, c2) -> Bool in
                    return c1.rawValue < c2.rawValue
                }
                
                self.quizzesByCategory = Dictionary(grouping: self.quizzes, by: { ($0.category) })
                
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

extension MainMenuViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesByCategory[ self.arrSections[section] ]?.count ?? 0 //return the number of quizzes for each category
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerText = UILabel()
        headerText.adjustsFontSizeToFitWidth = true
        switch section {
            case 0:
                headerText.textAlignment = .left
                headerText.text = "Science"
                headerText.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                headerText.textColor = UIColor(red: 46/256, green: 95/256, blue: 242/256, alpha: 1)
                headerText.font = UIFont.boldSystemFont(ofSize: 20)
            case 1:
                headerText.textAlignment = .left
                headerText.text = "Sports"
                headerText.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                headerText.textColor = UIColor(red: 3/256, green: 252/256, blue: 107/256, alpha: 1)
                headerText.font = UIFont.boldSystemFont(ofSize: 20)
            default:
                break
        }

        return headerText
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let section = arrSections[indexPath.section]
        let selectedQuiz = quizzesByCategory[section]?[indexPath.row]
        
        let quizVC = storyBoard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        quizVC.modalPresentationStyle = .fullScreen
        
        quizVC.quiz = selectedQuiz
        
        self.present(quizVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizCell
        
        let currentKey = arrSections[indexPath.section]

        let quiz = quizzesByCategory[currentKey]?[indexPath.row]
        
        cell.setQuiz(quiz: quiz!)
        
        return cell
    }
}
