//
//  ViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 30/04/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

struct Quizzes : Decodable {
    var name: String
    var arrQ: [Quiz]
}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, backgroundGradientView)
    }
    @IBAction func GetQuiz(_ sender: Any) {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
//                let quiz = try? JSONDecoder().decode(Quizzes.self, from: data)
                let jsonString = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
//                let quizzes = try? JSONDecoder().decode(Quizzes, from: jsonString)

                print(jsonString)
            } else {
                print("Error getting the data")
            }
            
        }.resume()
    }
}
