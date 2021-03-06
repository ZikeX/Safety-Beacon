//
//  NavigationViewController.swift
//  SafetyBeacon
//
//  Changes tracked by git: github.com/nathantannar4/Safety-Beacon
//
//  Edited by:
//      Nathan Tannar
//           - ntannar@sfu.ca
//      Philip Leblanc
//          - paleblan@sfu.ca
//

import UIKit
import NTComponents
import Mapbox
import MapboxDirections
import MapboxCoreNavigation

class NavigationViewController: MapViewController {
    
    // MARK: - Properties
    
    lazy var takeMeHomeButton: NTButton = { [weak self] in
        let button = NTButton()
        button.backgroundColor = .logoBlue
        button.titleColor = .white
        button.trackTouchLocation = false
        button.ripplePercent = 1
        button.setTitleColor(UIColor.white.withAlpha(0.3), for: .highlighted)
        button.setTitle("Home", for: .normal)
        button.titleFont = Font.Default.Title.withSize(22)
        button.addTarget(self, action: #selector(calculateRouteHome), for: .touchUpInside)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
        button.setDefaultShadow()
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let location = LocationManager.shared.currentLocation else { return }
        mapView.setCenter(location, zoomLevel: 12, animated: true)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(takeMeHomeButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        takeMeHomeButton.addConstraints(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 32, rightConstant: 32, widthConstant: 80, heightConstant: 80)
    }

    // MARK: - User Actions
    @objc
    func calculateRouteHome() {
        
        var directionsRoute: Route?
        
        // TODO: - use actual home address
        let home = CLLocationCoordinate2D(latitude: 49.11340930, longitude: -122.89621281)
        //use mapbox to trace the path to home from current location
        guard let currentLocation = LocationManager.shared.currentLocation else { return }
        let origin = Waypoint(coordinate: currentLocation, name: "Current Location")
        let destination = Waypoint(coordinate: home, name: "Home")
        
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .walking)
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = home
        annotation.title = "Home"
        mapView.addAnnotation(annotation)
        
        _ = Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            directionsRoute = route
            self.drawRoute(route: directionsRoute!)
        }
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline.
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
}
