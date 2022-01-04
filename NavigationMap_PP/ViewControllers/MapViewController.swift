//
//  ViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionTextField: UITextField!
    
    @IBOutlet weak var testTF: UITextField!
    
    let locationManager = CLLocationManager()
    var directionsArray: [MKDirections] = []
    var placeCoordinate: CLLocationCoordinate2D?
    
    let regionInMetres = 1_500.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // точность отображения
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // запрос авторизации
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func goButton(_ sender: Any) {
        setupPlacemark(textLocation: directionTextField.text!)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Save" {
            guard let saveFavourites = segue.destination as? FavouritesViewController else {return}
            saveFavourites.saveRoutes = directionTextField.text
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        let favouritesVC = unwindSegue.source as! FavouritesViewController
        testTF.text = favouritesVC.saveRoutes
    }
    
    
    func setupPlacemark(textLocation: String?) {
            guard let location = textLocation else {return}
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(location) { [self] (placemarks, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let placemarks = placemarks else {return}
                let placemark = placemarks.first
                
                let annotation = MKPointAnnotation()
                annotation.title = "От: \(textLocation!)"
                guard let placeMarkLocation = placemark?.location else {return}
                annotation.coordinate = placeMarkLocation.coordinate
                
                mapView?.showAnnotations([annotation], animated: true)
                mapView?.selectAnnotation(annotation, animated: true)
                
                mapThis(destinationCord: placeMarkLocation.coordinate)
        }
    }
    
    @IBAction func myLocationButton(_ sender: Any) {
        userLocation(mapKit: mapView)
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
    
    
    func mapThis(destinationCord: CLLocationCoordinate2D) {

        let sourceCordinate = (locationManager.location?.coordinate)!

        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)

        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)

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

            self.resetMapView(withNew: directions, mapKit: self.mapView) // удаляем старый маршрут при построении нового

            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    // удаляем старый маршрут при построении нового
    func resetMapView(withNew directions: MKDirections, mapKit: MKMapView) {
        mapKit.removeOverlays(mapKit.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    // Линия
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 2
        return render
    }
    
    
    
    
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let center = CLLocation(latitude: mapView.centerCoordinate.latitude , longitude: mapView.centerCoordinate.longitude) //центр карты
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
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
//
//            DispatchQueue.main.async {
//                if streetName != nil && buildNumber != nil {
//                        self.testLabel.text = "\(streetName!), \(buildNumber!)"
//                    } else if streetName != nil {
//                        self.testLabel.text = "\(streetName!)"
//                    } else {
//                        self.testLabel.text = ""
//
//            }
//          }
//        }
//    }
    
}

