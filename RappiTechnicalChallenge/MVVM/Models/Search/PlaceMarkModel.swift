//
//  PlaceMarkModel.swift
//  RappiTechnicalChallenge
//
//  Created by Angel Trejo Flores on 9/30/19.
//

import Foundation
import GoogleMaps

final class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        position = place.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        icon = UIImage(named: "restaurant_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}

final class GooglePlace {
    let idRestaurant: Int?
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D?
    var placeType: String
    var photoReference: String?
    var photo: UIImage?
    
    init(locationModel: NearbyRestaurantModel) {
        let foundType = "restaurant"
        name = locationModel.name
        address = locationModel.location.address
        idRestaurant = Int(locationModel.id)
        photoReference = locationModel.featuredImage
        placeType = foundType
        photo = nil
        if let lat = Double(locationModel.location.latitude),
            let lng = Double(locationModel.location.longitude) {
            let latitude = lat as CLLocationDegrees
            let longitude = lng as CLLocationDegrees
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            coordinate = nil
        }
    }
}
