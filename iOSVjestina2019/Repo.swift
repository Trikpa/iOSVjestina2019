//
//  Repo.swift
//  iOSVjestina2019
//
//  Created by Five on 01/05/2020.
//  Copyright © 2020 Algebra. All rights reserved.
//

import Foundation
import UIKit

class Repo {
    
    public static func createGradientBackground(_ view: UIView, _ backgroundGradientView: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        
        gradientLayer.colors = [
            UIColor(red: 196/255, green: 15/255, blue: 97/255, alpha: 1).cgColor,
            UIColor(red: 226/255, green: 114/255, blue: 16/255, alpha: 1).cgColor]
        
        gradientLayer.shouldRasterize = true
        
        backgroundGradientView.layer.addSublayer(gradientLayer)
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 1)
    }
}
