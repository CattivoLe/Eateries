//
//  PopularTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 22.01.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import CloudKit

class PopularTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []
    var publicDataBase = CKContainer.default().publicCloudDatabase

    override func viewDidLoad() {
        super.viewDidLoad()
        getCloudRecords()
        tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    }
    
    // MARK: - iCloud getData Stack
    func getCloudRecords() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        //let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        //query.sortDescriptors = [sort] // Применить сортировку
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name","image"] // Получить данные по ключам
        queryOperation.resultsLimit = 10
        queryOperation.queuePriority = .veryHigh
        queryOperation.recordFetchedBlock = { (record: CKRecord!) in
            if let record = record {
                self.restaurants.append(record)
            }
        }
        queryOperation.queryCompletionBlock = { (cursor, error) in
            guard error == nil else {
                print("Не удалось получить данные из iCloud\(error!.localizedDescription)")
                return
            }
            print("Данные получены")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        publicDataBase.add(queryOperation)

//        Получение всех данных сразу
//        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
//            guard error == nil else {
//               print(error!)
//                return
//            }
//            if let records = records {
//                self.restaurants = records
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        if let image = restaurant.object(forKey: "image") {
            let image = image as! CKAsset
            let data = try? Data(contentsOf: image.fileURL)
            if let data = data {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        cell.backgroundColor = UIColor.clear // Прозрачная ячейка
        return cell
    }

}
