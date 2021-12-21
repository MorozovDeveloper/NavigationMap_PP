//
//  ViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var testLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMetres = 1_500.00
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conteinerView.isHidden = true
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // точность отображения
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // запрос авторизации
        locationManager.startUpdatingLocation()

    }
    
    
    @IBAction func searchMenuButton(_ sender: Any) {
        conteinerView.isHidden = false
        
    }
    
    @IBAction func myLocationButton(_ sender: Any) {
        userLocation(mapKit: mapView)
        
    }
    
    @IBAction func favouritesButton(_ sender: Any) {
        
    }
    
    // Нахождение юзера
    func userLocation(mapKit: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMetres,
                                            longitudinalMeters: regionInMetres)
            mapKit.setRegion(region, animated: true)
            mapKit.showsUserLocation = true
            
        }
    }
    
    // Определяем центр карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare // определяем название улицы
            let buildNumber = placemark?.subThoroughfare // определяем номер дома
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.testLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.testLabel.text = "\(streetName!)"
                } else {
                    self.testLabel.text = ""
                }
            }
        }
    }
    
}

