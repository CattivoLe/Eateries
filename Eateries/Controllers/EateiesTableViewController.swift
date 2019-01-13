//
//  EateiesTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 13/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class EateiesTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Model
    
    var restaurantNames = ["Ogonёk Grill&Bar", "Елу", "Bonsai", "Дастархан", "Индокитай", "X.O", "Балкан Гриль", "Respublica", "Speak Easy", "Morris Pub", "Вкусные истории", "Классик", "Love&Life", "Шок", "Бочка"]
    
    var restaurantImages = ["ogonek.jpg", "elu.jpg", "bonsai.jpg", "dastarhan.jpg", "indokitay.jpg", "x.o.jpg", "balkan.jpg", "respublika.jpg", "speakeasy.jpg", "morris.jpg", "istorii.jpg", "klassik.jpg", "love.jpg", "shok.jpg", "bochka.jpg"]
    
    var restoranVisited = [Bool](repeating: false, count: 15)
    
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
        cell.accessoryType = self.restoranVisited[indexPath.row] ? .checkmark : .none
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
        
        let visitedTitle = self.restoranVisited[indexPath.row] ? "Я не был сдесь" : "Я был сдесь"
        let visited = UIAlertAction(title: visitedTitle, style: .default) { (action) in
            let cell = tableView.cellForRow(at: indexPath)
            self.restoranVisited[indexPath.row] = !self.restoranVisited[indexPath.row]
            cell?.accessoryType = self.restoranVisited[indexPath.row] ? .checkmark : .none
        }
        allertController.addAction(cancelButtone)
        allertController.addAction(callAction)
        allertController.addAction(visited)
        present(allertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let defaultText = "Я сейчас в " + self.restaurantNames[indexPath.row]
            if let image = UIImage(named: self.restaurantImages[indexPath.row]) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delite = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            self.restaurantNames.remove(at: indexPath.row)
            self.restaurantImages.remove(at: indexPath.row)
            self.restoranVisited.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delite.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [delite, share]
    }
    
    
}
