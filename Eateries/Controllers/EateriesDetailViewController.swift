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
    @IBOutlet weak var rateButton: UIButton!
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    var restourant: Restaurant?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false // Не скрывать по свайпу
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: restourant!.image)
        rateButton.layer.cornerRadius = 5
        rateButton.layer.borderWidth = 1
        rateButton.layer.borderColor = UIColor.white.cgColor
        
        tableView.estimatedRowHeight = 38 // Размер ячейки
        tableView.rowHeight = UITableView.automaticDimension // Автоматический размер ячейки
        tableView.tableFooterView = UIView(frame: CGRect.zero) // Скрыть неиспользуемую часть таблицы
        title = restourant!.name // Заголовок
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesDetailTableViewCell
        cell.backgroundColor = UIColor.clear // Прозрачные ячейки
        
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
