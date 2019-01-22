//
//  AboutTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 22.01.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    let sectionsHeaders = ["Социальные сети", "Сайты"]
    let sectionsContent = [["FaceBook","Vk","YouTube"],["VideoHubControll","PianoTrener"]]
    let firstSectionLinks = ["https://www.facebook.com","https://www.vk.com","https://www.youtube.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRect.zero) // Скрыть пустую часть таблицы
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsHeaders[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionsContent[indexPath.section][indexPath.row]
        cell.backgroundColor = UIColor.clear // Прозрачные ячейки
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0..<firstSectionLinks.count :
                performSegue(withIdentifier: "showWebPageSegue", sender: self)
            default: break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebPageSegue" { // Передача ссылки
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! WebViewController
                dvc.url = URL(string: firstSectionLinks[indexPath.row])
            }
        }
    }
}
