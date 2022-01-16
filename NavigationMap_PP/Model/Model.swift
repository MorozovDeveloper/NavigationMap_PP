//
//  Model.swift
//  NavigationMap_PP
//
//  Created by Oleg on 05.01.2022.
///

import UIKit
import MapKit

struct ModelMap {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    var placeCoordinate: CLLocationCoordinate2D?
    
    let regionInMetres = 1_500.00
}
