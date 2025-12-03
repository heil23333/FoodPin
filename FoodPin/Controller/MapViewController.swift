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
                    
                    self.mapView.showAnnotations( [annotation], animated: true)//放置大头针
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"//这里MyMarker可以任意取名, 只是为了复用区别
        if annotation.isKind(of: MKUserLocation.self) {//MKUserLocation是系统自动创建的注解, 不能自定义显示
            return nil//返回nil表示由系统处理
        }
        
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView//复用annotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.glyphText = "🎈"//标记上显示的文字
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
}
