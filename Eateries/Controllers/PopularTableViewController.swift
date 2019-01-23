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
    var spinner: UIActivityIndicatorView!
    var cache = NSCache<CKRecord.ID, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - RefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        refreshControl?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        refreshControl?.addTarget(self, action: #selector(getCloudRecords), for: .valueChanged)
        
        //MARK: - ActivityIndicator Stack
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false // Не проставлять авто ограничения
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.addSubview(spinner)
        
        //spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        //spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 0.85, constant: 0).isActive = true
        
        getCloudRecords()
        tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    }
    
    // MARK: - iCloud getData Stack
    @objc func getCloudRecords() {
        
        restaurants = []
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        query.sortDescriptors = [sort] // Применить сортировку
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"] // Получить данные по ключам
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
                self.spinner.stopAnimating()
                self.refreshControl?.endRefreshing()
            }
        }
        publicDataBase.add(queryOperation)
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
        cell.imageView?.image = UIImage(named: "photo") // Картинка из ассетов пока не загрузятся данные
        
        if let imageURL = cache.object(forKey: restaurant.recordID) as? URL { // Читать из кэша
            if let data = try? Data(contentsOf: imageURL) {
                cell.imageView?.image = UIImage(data: data)
            }
        } else {
            
        let fetchRecordOper = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordOper.desiredKeys = ["image"]
        fetchRecordOper.queuePriority = .veryHigh
        fetchRecordOper.perRecordCompletionBlock = { (record, recordID, error) in
            guard error == nil else {
                print("Не удалось загрузить изображение из Icloud")
                return
            }
            guard let record = record else { return }
            guard let image = record.object(forKey: "image") else { return }
            let imageAsset = image as! CKAsset
            
            guard let data = try? Data(contentsOf: imageAsset.fileURL) else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data)
                self.cache.setObject(imageAsset.fileURL as AnyObject, forKey: restaurant.recordID) // Запись в кэш
            }
        }
        publicDataBase.add(fetchRecordOper)
        }
        cell.backgroundColor = UIColor.clear // Прозрачная ячейка
        return cell
    }
}
