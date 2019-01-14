//
//  RateViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 14/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var briliantBotton: UIButton!
    
    var restRating:String?
    
    // MARK: - Кнопки рейтинга
    
    @IBAction func rateRestourantButtons(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            restRating = "bad"
        case 1:
            restRating = "good"
        case 2:
            restRating = "brilliant"
        default:
            break
        }
        
        performSegue(withIdentifier: "UnwindSegueToDVT", sender: sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // MARK: - Анимация кнопок
        
        let buttonArray = [badButton, goodButton, briliantBotton]
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Анимация, стартовая позиция
        
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        briliantBotton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // MARK: - Эффект размытия заднего фона
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.insertSubview(blurEffectView, at: 1)
    }
    
}
