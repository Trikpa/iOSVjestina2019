//
//  LoginScreenViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 26/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

class LoginScreenViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Repo.createGradientBackground(view, backgroundGradientView)
        
        let token = UserDefaults.standard.string(forKey: "token")
        if (token != "") {
            DispatchQueue.main.async {
                self.loginSuccessful()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUsername {
            textField.resignFirstResponder()
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            textField.resignFirstResponder()
            loginButton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let username = tfUsername.text
        let password = tfPassword.text
        
        if (username == "" || password == "") {
            return
        }
        
        loginButton.isEnabled = false
        loginUser(username!, password!);
    }
    
    fileprivate func loginUser(_ username: String, _ password: String) {
        let url = URL(string: "https://iosquiz.herokuapp.com/api/session")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramsToSend = "username=" + username + "&password=" + password
        request.httpBody = paramsToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
         (data, response, error) in
            guard let data: Data = data else {
                return
            }
            
            let session: Session
            do {
                session = try JSONDecoder().decode(Session.self, from: data)
            } catch {
                DispatchQueue.main.sync {
                    self.errorLabel.text = "Username or password are incorrect!"
                    self.errorLabel.isHidden = false
                }
                return
            }
            self.errorLabel.isHidden = true
                        
            let preferences = UserDefaults.standard
            preferences.set(session.token, forKey: "token")
            preferences.set(session.userID, forKey: "userID")
                                
            DispatchQueue.main.async {
                self.loginSuccessful()
            }
        })
        task.resume()
        loginButton.isEnabled = true
    }
    
    func loginSuccessful() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TabBarViewController") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
