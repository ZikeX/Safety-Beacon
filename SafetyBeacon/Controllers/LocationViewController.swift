//
//  LocationViewController.swift
//  SafetyBeacon
//
//  Created by Nathan Tannar on 9/25/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    // MARK: - Properties
    
    var location: Location
    
    // MARK: - Initialization
    
    init(_ locationToView: Location) {
        location = locationToView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - User Actions
}
