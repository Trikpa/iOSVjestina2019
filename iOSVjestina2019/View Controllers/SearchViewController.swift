//
//  SearchViewController.swift
//  iOSVjestina2019
//
//  Created by Five on 01/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var backgroundGradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repo.createGradientBackground(view, backgroundGradientView)
    }
    
}
