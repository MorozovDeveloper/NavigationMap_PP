//
//  MapManager.swift
//  NavigationMap_PP
//
//  Created by Oleg on 05.01.2022.
//

import UIKit
import MapKit

extension MapViewController {
    
    // Поиск и создание метки
    func setupPlacemark(textLocation: String?) {
        guard let location = textLocation else {return}
        
        ModelMap.share.geocoder.geocodeAddressString(location) { [self] (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "До: \(textLocation!)"
            guard let placeMarkLocation = placemark?.location else {return}
            annotation.coordinate = placeMarkLocation.coordinate
            
            mapView?.showAnnotations([annotation], animated: true)
            mapView?.selectAnnotation(annotation, animated: true)
            
            mapThis(destinationCord: placeMarkLocation.coordinate)
        }
    }
    
    // Нахождение юзера
    func userLocation(mapKit: MKMapView) {
        if let location = ModelMap.share.locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: ModelMap.share.regionInMetres,
                                            longitudinalMeters: ModelMap.share.regionInMetres)
            mapKit.setRegion(region, animated: true)
            mapKit.showsUserLocation = true
        }
    }
    
    // Построение маршрута
    func mapThis(destinationCord: CLLocationCoordinate2D) {
        let sourceCordinate = (ModelMap.share.locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print("Something is wrong")
                }
                return
            }
            
            self.resetMapView(withNew: directions, mapKit: self.mapView)// удаление старого маршрута
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    // Удаление старого маршрута при построении нового
    func resetMapView(withNew directions: MKDirections, mapKit: MKMapView) {
        mapKit.removeOverlays(mapKit.overlays)
        ModelMap.share.directionsArray.append(directions)
        let _ = ModelMap.share.directionsArray.map { $0.cancel() }
        ModelMap.share.directionsArray.removeAll()
    }
    
    // Линия
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .systemBlue
        render.lineWidth = 3
        return render
    }
    
    // Определение адреса в реальном времени
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = CLLocation(latitude: mapView.centerCoordinate.latitude , longitude: mapView.centerCoordinate.longitude) //центр карты
        
        ModelMap.share.geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare // название улицы
            let buildNumber = placemark?.subThoroughfare // номер дома
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.directionTextField.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.directionTextField.text = "\(streetName!)"
                } else {
                    self.directionTextField.text = ""
                    
                }
            }
        }
    }
    
}

