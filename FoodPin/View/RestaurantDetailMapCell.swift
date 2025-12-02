//
//  RestaurantDetailSeparatorCell.swift
//  FoodPin
//
//  Created by  He on 2025/12/2.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {
    @IBOutlet var mapView: MKMapView! {
        didSet {
            mapView.layer.cornerRadius = 20
            mapView.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let placemarks = placemarks {
                let firstPlacemark = placemarks.first//可能获得多个结果(如果地址不够精确)
                let annotation = MKPointAnnotation()
                if let location = firstPlacemark?.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                    
                }
            }
        }
    }

}
