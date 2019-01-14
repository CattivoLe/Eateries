//
//  MapViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 14/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geocoder = CLGeocoder() // Конверирует координаты в строку и наоборот
        
        geocoder.geocodeAddressString(restaurant.location) { (placemarks, error) in // Передаем адрес ресторана
            guard error == nil else { return } // Проверяем на ошибки
            guard let placemarks = placemarks else { return } // Проверяем что получили координаты
            
            let placemark = placemarks.first // Создаем точку из первого полученного адреса
            
            let annotation = MKPointAnnotation() // Подпись точки на карте
            annotation.title = self.restaurant.name
            annotation.subtitle = self.restaurant.type
            
            guard let location = placemark!.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true) // Показать Точку на карте
            self.mapView.selectAnnotation(annotation, animated: true) // Раскрыть аннотации к точке
            
        }
    }
    
}
