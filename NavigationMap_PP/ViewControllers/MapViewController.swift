//
//  ViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var testLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var directionsArray: [MKDirections] = []
    var placeCoordinate: CLLocationCoordinate2D?
    
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
    
    
    // удаляем старый маршрут при построении нового
    func resetMapView(withNew directions: MKDirections, mapKit: MKMapView) {
        mapKit.removeOverlays(mapKit.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func mapThis(destinationCord: CLLocationCoordinate2D) {
        
        let sourceCordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destPlaceMArk = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMArk)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something is wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    // Линия
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 2
        return render
    }
    
    
    
    
    
    
    
    
    // Пока не нужно
    // Определяем центр карты
//    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
//        let latitude = mapView.centerCoordinate.latitude
//        let longitude = mapView.centerCoordinate.longitude
//
//        return CLLocation(latitude: latitude, longitude: longitude)
//    }
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let center = getCenterLocation(for: mapView)
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
//
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let placemarks = placemarks else {return}
//
//            let placemark = placemarks.first
//            let streetName = placemark?.thoroughfare // определяем название улицы
//            let buildNumber = placemark?.subThoroughfare // определяем номер дома
//
//            DispatchQueue.main.async {
//                if streetName != nil && buildNumber != nil {
//                    self.testLabel.text = "\(streetName!), \(buildNumber!)"
//                } else if streetName != nil {
//                    self.testLabel.text = "\(streetName!)"
//                } else {
//                    self.testLabel.text = ""
//                }
//            }
//        }
//    }
    
}

