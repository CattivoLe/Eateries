//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 13/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class EateiesTableViewController: UITableViewController {
    
    var restaurants: [Restaurant] = []
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true // Скрывать верхний бар по свайпу
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -  Подстройка таблицы
        tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        tableView.estimatedRowHeight = 85 // Размер ячейки
        tableView.rowHeight = UITableView.automaticDimension // Авторазмер ячейки
        
        // MARK: - Скрыть текст кнопки назад
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        cell.thumbnailImageView.image = UIImage(data: restaurants[indexPath.row].image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true // Скругление картинки
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
        cell.backgroundColor = UIColor.clear // Прозрачная ячейка
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Снять выделение после нажатия
    }
    
    // MARK: - Действия по свайпу в сторону
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Кнопка "Поделиться"
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        // Кнопка "Удалить"
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
                dvc.restourant = self.restaurants[indexPath.row]
            }
        }
    }
}
