//
//  EateiesTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 13/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class EateiesTableViewController: UITableViewController {
    
    let restaurantNames = ["Ogonёk Grill&Bar", "Елу", "Bonsai", "Дастархан", "Индокитай", "X.O", "Балкан Гриль", "Respublica", "Speak Easy", "Morris Pub", "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"]
    
    let restaurantImages = ["ogonek.jpg", "elu.jpg", "bonsai.jpg", "dastarhan.jpg", "indokitay.jpg", "x.o.jpg", "balkan.jpg", "respublika.jpg", "speakeasy.jpg", "morris.jpg", "istorii.jpg", "klassik.jpg", "love.jpg", "shok.jpg", "bochka.jpg"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        cell.thumbnailImageView.image = UIImage(named: restaurantImages[indexPath.row])
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurantNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let allertController = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
        let cancelButtone = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let callAction = UIAlertAction(title: "Позвонить: +7(495)555 00 0\(indexPath.row)", style: .default) {
            (action: UIAlertAction) -> Void in
            let alertController = UIAlertController(title: nil, message: "Вызов не может быть совершен", preferredStyle: .alert)
            let button = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(button)
            self.present(alertController, animated: true, completion: nil)
        }
        let visited = UIAlertAction(title: "Я был сдесь", style: .default) { (action) in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
        }
        allertController.addAction(cancelButtone)
        allertController.addAction(callAction)
        allertController.addAction(visited)
        present(allertController, animated: true, completion: nil)
        
    }
    
    
}
