//
//  SettingsViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 26/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var backgroundGradientView: UIView!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Repo.createGradientBackground(view, backgroundGradientView)
        userIDLabel.text = "User ID: \(UserDefaults.standard.string(forKey: "userID") ?? "None")"
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        resetUserDefaults()
        showLoginScreen()
    }
    
    fileprivate func resetUserDefaults() {
        let preferences = UserDefaults.standard
        preferences.set("", forKey: "token")
        preferences.set(0, forKey: "userID")
    }
    
    fileprivate func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginScreenViewController") as! LoginScreenViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
