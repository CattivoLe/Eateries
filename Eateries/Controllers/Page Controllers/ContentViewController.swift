//
//  ContentViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 18.01.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var header = ""
    var subHeader = ""
    var imageFile = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
