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
    
    public static func createGradientBackground(_ view: UIView, _ backgroundGradientView: UIView)
    {
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
    
    public static func getImage(urlString: String) -> UIImageView {
        let url = URL(string: urlString)!
        let imageView = UIImageView()

        let data = try? Data(contentsOf: url)
        imageView.image = UIImage(data: data!)
        
        return imageView
    }
    
    public static func correctAnswerColor() -> UIColor {
        return UIColor(red: 78/256, green: 224/256, blue: 100/256, alpha: 1)
    }
    
    public static func wrongAnswerColor() -> UIColor {
        return UIColor(red: 224/256, green: 61/256, blue: 85/256, alpha: 1)
    }
}
