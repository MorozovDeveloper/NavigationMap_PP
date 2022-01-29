//
//  ViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    var delegateFavouritesVC = FavouritesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        stackView.layer.cornerRadius = 15
        directionTextField.layer.shadowOpacity = 0.7
        directionTextField.layer.shadowRadius = 5
        
        ModelMap.share.locationManager.desiredAccuracy = kCLLocationAccuracyBest // точность отображения
        ModelMap.share.locationManager.delegate = self
        ModelMap.share.locationManager.requestWhenInUseAuthorization() // запрос авторизации
        ModelMap.share.locationManager.startUpdatingLocation()
    }
    
    // Избранное
    @IBAction func favouritesButton() {
        delegateFavouritesVC.saveTask(withTitle: directionTextField.text!)
    }
    
    // Поиск
    @IBAction func goButton() {
        setupPlacemark(textLocation: directionTextField.text!)
    }
    
    // Текущее местонахождение
    @IBAction func myLocationButton() {
        userLocation(mapKit: mapView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Save" {
            ModelMap.share.saveRoutes = directionTextField.text
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        guard let favouritesVC = unwindSegue.source as? FavouritesViewController else {return}
        if let indexPath = favouritesVC.tableView.indexPathForSelectedRow {
            setupPlacemark(textLocation: favouritesVC.tasks[indexPath.row].title)
            directionTextField.text = favouritesVC.tasks[indexPath.row].title
        }
    }
    
}

