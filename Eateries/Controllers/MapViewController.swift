//
//  MapViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 14/01/2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Geocoder stack
        mapView.delegate = self
        let geocoder = CLGeocoder() // Конверирует координаты в строку и наоборот
        geocoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in // Передаем адрес ресторана
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationIdentifire = "restAnnotation"
        var annotatioView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifire) as? MKPinAnnotationView
        
        if annotatioView == nil {
            annotatioView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifire)
            annotatioView?.canShowCallout = true
        }
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightImage.image = UIImage(data: restaurant.image! as Data)
        annotatioView?.rightCalloutAccessoryView = rightImage
        annotatioView?.pinTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return annotatioView
    }
}
