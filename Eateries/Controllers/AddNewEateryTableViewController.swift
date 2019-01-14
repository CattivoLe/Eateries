//
//  AddNewEateryTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 15/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class AddNewEateryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // MARK: - Аллерт выбор картинки
            let alertController = UIAlertController(title: "Выбрать картинку", message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
                self.chooseImagePickerAction(source: .camera)
            }
            let photoLibAction = UIAlertAction(title: "Фото", style: .default) { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true) // Снять выделение
    }
    // MARK: - ImagePicker Controller
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) { // Проверка доступности камеры или библиотеки
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true // Разрешить редактировать картинку после выбора
            imagePicker.sourceType = source // Камера иди библиотека картинок
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
}
