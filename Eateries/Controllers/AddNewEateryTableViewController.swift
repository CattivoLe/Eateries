//
//  AddNewEateryTableViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 15/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class AddNewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var visitedStatus = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adresTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBAction func toggelIsVisitedPressed(_ sender: UIButton) {
        if sender == yesButton {
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.7301866559, blue: 0, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            visitedStatus = true
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.7344238162, green: 0.1379992366, blue: 0.148756355, alpha: 1)
            yesButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            visitedStatus = false
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || adresTextField.text == "" || typeTextField.text == "" {
            let alert = UIAlertController(title: "Упсc..", message: "Не все поля заполнены", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindSegueFromNew", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.backgroundColor = #colorLiteral(red: 0, green: 0.7301866559, blue: 0, alpha: 1)
        noButton.backgroundColor = #colorLiteral(red: 0.7344238162, green: 0.1379992366, blue: 0.148756355, alpha: 1)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage // Извлечение полученного изображения
        imageView.contentMode = .scaleAspectFill // Режим отображения
        imageView.clipsToBounds = true // Обрезать все что за рамками супервью
        dismiss(animated: true, completion: nil)
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
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // Разрешить редактировать картинку после выбора
            imagePicker.sourceType = source // Камера иди библиотека картинок
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
}
