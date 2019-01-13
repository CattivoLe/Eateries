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
    
    var restaurants: [Restaurant] = [
        Restaurant(name: "Ogonёk Grill&Bar", type: "ресторан", location: "Уфа", image: "ogonek.jpg", isVisited: false),
        Restaurant(name: "Елу", type: "ресторан", location: "Уфа", image: "elu.jpg", isVisited: false),
        Restaurant(name: "Bonsai", type: "ресторан", location: "Уфа", image: "bonsai.jpg", isVisited: false),
        Restaurant(name: "Дастархан", type: "ресторан", location: "Уфа", image: "dastarhan.jpg", isVisited: false),
        Restaurant(name: "Индокитай", type: "ресторан", location: "Уфа", image: "indokitay.jpg", isVisited: false),
        Restaurant(name: "X.O", type: "ресторан-клуб", location: "Уфа", image: "x.o.jpg", isVisited: false),
        Restaurant(name: "Балкан Гриль", type: "ресторан", location: "Уфа", image: "balkan.jpg", isVisited: false),
        Restaurant(name: "Respublica", type: "ресторан", location: "Уфа", image: "respublika.jpg", isVisited: false),
        Restaurant(name: "Speak Easy", type: "ресторанный комплекс", location: "Уфа", image: "speakeasy.jpg", isVisited: false),
        Restaurant(name: "Morris Pub", type: "ресторан", location: "Уфа", image: "morris.jpg", isVisited: false),
        Restaurant(name: "Вкусные истории", type: "ресторан", location: "Уфа", image: "istorii.jpg", isVisited: false),
        Restaurant(name: "Классик", type: "ресторан", location: "Уфа", image: "klassik.jpg", isVisited: false),
        Restaurant(name: "Love&Life", type: "ресторан", location: "Уфа", image: "love.jpg", isVisited: false),
        Restaurant(name: "Шок", type: "ресторан", location: "Уфа", image: "shok.jpg", isVisited: false),
        Restaurant(name: "Бочка", type: "ресторан", location:  "Уфа", image: "bochka.jpg", isVisited: false)]
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let allertController = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
//        let cancelButtone = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        let callAction = UIAlertAction(title: "Позвонить: +7(495)555 00 0\(indexPath.row)", style: .default) {
//            (action: UIAlertAction) -> Void in
//            let alertController = UIAlertController(title: nil, message: "Вызов не может быть совершен", preferredStyle: .alert)
//            let button = UIAlertAction(title: "Ok", style: .default, handler: nil)
//            alertController.addAction(button)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        let visitedTitle = self.restoranVisited[indexPath.row] ? "Я не был сдесь" : "Я был сдесь"
//        let visited = UIAlertAction(title: visitedTitle, style: .default) { (action) in
//            let cell = tableView.cellForRow(at: indexPath)
//            self.restoranVisited[indexPath.row] = !self.restoranVisited[indexPath.row]
//            cell?.accessoryType = self.restoranVisited[indexPath.row] ? .checkmark : .none
//        }
//        allertController.addAction(cancelButtone)
//        allertController.addAction(callAction)
//        allertController.addAction(visited)
//        present(allertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name
            if let image = UIImage(named: self.restaurants[indexPath.row].image) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delite = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delite.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [delite, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateiesDetailViewController
                dvc.imageName = self.restaurants[indexPath.row].image
            }
        }
    }
    
    
}
