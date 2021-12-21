//
//  ContainerViewController.swift
//  NavigationMap_PP
//
//  Created by Oleg on 16.12.2021.
// Тверская 2

import UIKit
import MapKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
        
        goButton.isEnabled = false
        fromTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        whereTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        if fromTextField.text?.isEmpty == false && whereTextField.text?.isEmpty == false {
            goButton.isEnabled = true
        } else {
            goButton.isEnabled = false
        }
        
    }
    
    @IBAction func goButton(_ sender: Any) {
        DispatchQueue.main.async { [self] in // для одновременного отображения 2х точек
            setupPlacemark(textLocation: fromTextField.text!)
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) { [self] in
            secondSetupPlacemark(textLocation: whereTextField.text!)
        }
        
    }
    

    func setupPlacemark(textLocation: String?) {
        if let mapVC = parent as? ViewController {
            
            guard let location = textLocation else {return}
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let placemarks = placemarks else {return}
                let placemark = placemarks.first
                
                let annotation = MKPointAnnotation()
                annotation.title = "От: \(textLocation!)"
                
                guard let plaseMarkLocation = placemark?.location else {return}
                annotation.coordinate = plaseMarkLocation.coordinate
                
                mapVC.mapView.showAnnotations([annotation], animated: true)
                mapVC.mapView.selectAnnotation(annotation, animated: true)
                
                print("От")
                
            }
        }
    }
    
    
    func secondSetupPlacemark(textLocation: String?) {
        if let mapVC = parent as? ViewController {
            
            guard let location = textLocation else {return}
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let placemarks = placemarks else {return}
                let placemark = placemarks.first
                
                let annotation = MKPointAnnotation()
                annotation.title = "До: \(textLocation!)"
                
                guard let plaseMarkLocation = placemark?.location else {return}
                annotation.coordinate = plaseMarkLocation.coordinate
                
                mapVC.mapView.showAnnotations([annotation], animated: true)
                mapVC.mapView.selectAnnotation(annotation, animated: true)
                
                print("До")
            }
        }
    }
    
}
