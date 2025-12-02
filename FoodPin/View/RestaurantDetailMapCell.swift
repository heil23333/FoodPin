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

}
