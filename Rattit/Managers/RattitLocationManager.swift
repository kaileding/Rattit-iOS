//
//  RattitLocationManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/29/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import CoreLocation

class RattitLocationManager: NSObject {
    
    var currentLocation: CLLocation? = nil
    var loadedNearbyPlacesFromGoogle: [GoogleLocation] = []
    var pageTokenForMoreNearbyPlaces: String? = nil
    var lastRefreshTime: Date? = nil
    
    var locationManager: CLLocationManager! = CLLocationManager()
    
    static let sharedInstance: RattitLocationManager = RattitLocationManager()
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func getNearbyPlaces(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if self.currentLocation != nil {
            let currentLongitude = self.currentLocation!.coordinate.longitude
            let currentLatitude = self.currentLocation!.coordinate.latitude
            
            Network.sharedInstance.callRattitContentService(httpRequest: .getNearbyPlacesFromGoogle(latitude: currentLatitude, longitude: currentLongitude, withinDistance: 300.0, type: "Restaurant"), completion: { (dataValue) in
                
                if let responseBody = dataValue as? [String: Any], let results = responseBody["results"] as? [Any] {
                    if let nextPageToken = responseBody["next_page_token"] as? String {
                        self.pageTokenForMoreNearbyPlaces = nextPageToken
                    }
                    
                    results.forEach({ (dataValue) in
                        if let googleLocation = GoogleLocation(dataValue: dataValue) {
                            self.loadedNearbyPlacesFromGoogle.append(googleLocation)
                        }
                    })
                    
                    DispatchQueue.main.async {
                        self.lastRefreshTime = Date()
                        completion()
                    }
                    
                } else {
                    errorHandler(RattitError.parseError(message: "Unable to parse dataValue into json type."))
                }
                
            }, errorHandler: { (error) in
                errorHandler(error)
            })
        }
        
    }
    
    func updateCurrentLocation() {
        self.locationManager.requestLocation()
    }
    
    // utilities
    func getDistanceFromCurrentLocation(forLocation: CLLocation) -> String {
        var distance = 0.0
        if self.currentLocation != nil {
            distance = self.currentLocation!.distance(from: forLocation)
        }
        
        let distanceStr = String(format: "%.2f m", distance)
        
//        print("\ncurrentLocation: \(self.currentLocation!.coordinate), forLocation: \(forLocation.coordinate), distance is: \(distance) - \(distanceStr)")
        
        return distanceStr
    }
}

extension RattitLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let latestLocation = locations.last {
            self.currentLocation = latestLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManagerDelegate func. didFailWithError: \(error.localizedDescription)")
        
        manager.requestWhenInUseAuthorization()
    }
    
}
