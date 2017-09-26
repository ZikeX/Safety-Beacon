//
//  LocationManager.swift
//  SafetyBeacon
//
//  Created by Nathan Tannar on 9/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static var shared: LocationManager {
        return LocationManager()
    }
    
    // MARK: - Properties
    
    var currentLocation: CLLocationCoordinate2D? {
        guard let location = coreLocationManager.location else {
            Log.write(.warning, "Failed to get the users current location. Was auth given?")
            return nil
        }
        return CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    // MARK: - Private Properties
    
    private lazy var coreLocationManager: CLLocationManager = { [weak self] in
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Functions
    
    /// Promts the user for location accesss authorization
    func requestAlwaysAuthorization() {
        coreLocationManager.requestAlwaysAuthorization()
    }
    
    /// Saves the current users location to the server for processing
    ///
    /// - Returns: If the push was successful
    func saveCurrentLocation() -> Bool {
        
//        guard let location = currentLocation, let user = User.current() else {
//            Log.write(.warning, "Failed to save the users current location")
//            return false
//        }
        
        // save to DB here
        return true
    }
    
    // MARK: - Private Functions
    
    private func beginTracking() {
        DispatchQueue.global(qos: .background).async {
            self.coreLocationManager.startUpdatingLocation()
            self.coreLocationManager.startMonitoringVisits()
        }
    }
    
    private func endTracking() {
        DispatchQueue.global(qos: .background).async {
            self.coreLocationManager.stopUpdatingLocation()
            self.coreLocationManager.stopMonitoringVisits()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        Log.write(.status, "locationManagerDidResumeLocationUpdates")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        Log.write(.status, "locationManagerDidPauseLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.write(.error, "locationManagerDidFailWithError: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        Log.write(.status, "locationManagerDidVisit: \(visit)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        Log.write(.status, "locationManagerDidEnterRegion: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        Log.write(.status, "locationManagerDidExitRegion: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Log.write(.status, "locationManagerDidUpdateLocations: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Log.write(.status, "locationManagerDidChangeAuthorizationStatus: \(status)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Location services are authorised, track the user.
            beginTracking()
        case .denied, .restricted:
            // Location services not authorised, stop tracking the user.
            endTracking()
        default:
            // Location services pending authorisation.
            // Alert requesting access is visible at this point.
            break
        }
    }
}