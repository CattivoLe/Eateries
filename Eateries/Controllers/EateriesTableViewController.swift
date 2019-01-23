//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 13/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import CoreData

class EateiesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filtredResult: [Restaurant] = []
    var restaurants: [Restaurant] = []
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true // Скрывать верхний бар по свайпу
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Search Controller
        searchController = UISearchController(searchResultsController: nil) // Отображать результат в текущем контроллере
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false // Не затемнять контролер при вводе
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        definesPresentationContext = true // Не отображать строку поиска на следующем экране
        // MARK: -  Подстройка таблицы
        tableView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        tableView.estimatedRowHeight = 85 // Размер ячейки
        tableView.rowHeight = UITableView.automaticDimension // Авторазмер ячейки
        // MARK: - Скрыть текст кнопки назад
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // MARK: - CoreData Load
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest() // Запрос
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) // Фильтр
        fetchRequest.sortDescriptors = [sortDescriptor] // Сортировать по полю "name" в порядке увеличения
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // Добираемся до контекста
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                restaurants = fetchResultsController.fetchedObjects! // Сохраняем полученные данные в массив
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil) // Отобразить PageViewController
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Fetch Results Controller delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func filterContentFor(searchText text: String) {
        filtredResult = restaurants.filter { (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))! // Добавить в массив только ресторан чье имя совпадает со строкой запроса
        }
    }
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filtredResult[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filtredResult.count
        }
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true // Скругление картинки
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
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
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelite = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelite)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delite.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        return [delite, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateiesDetailViewController
                dvc.restourant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

extension EateiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}
extension EateiesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
