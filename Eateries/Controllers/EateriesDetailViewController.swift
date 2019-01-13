//
//  EateriesDetailViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 13/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class EateiesDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var restourant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: restourant!.image)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = restourant!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = restourant!.type
        case 2:
            cell.keyLabel.text = "Адрес"
            cell.valueLabel.text = restourant!.location
        case 3:
            cell.keyLabel.text = "Я там был?"
            cell.valueLabel.text = restourant!.isVisited ? "Да" : "Нет"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
