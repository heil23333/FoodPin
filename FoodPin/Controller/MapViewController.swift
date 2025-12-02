//
//  MapViewController.swift
//  FoodPin
//
//  Created by  He on 2025/12/2.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: Restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location) { placemarks, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let placemarks = placemarks {
                let firstPlacemark = placemarks.first//可能获得多个结果(如果地址不够精确)
                
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = firstPlacemark?.location {
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations( [annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }

}
