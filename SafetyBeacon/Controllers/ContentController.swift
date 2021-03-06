//
//  AppController.swift
//  SafetyBeacon
//
//  Changes tracked by git: github.com/nathantannar4/Safety-Beacon
//
//  Edited by:
//      Nathan Tannar
//           - ntannar@sfu.ca
//

import NTComponents

class ContentController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        let settingsButton = NTButton()
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        settingsButton.image = #imageLiteral(resourceName: "icons8-settings")
        settingsButton.backgroundColor = .clear
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
        
        let titleLabel = NTLabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "Safety Beacon"
        titleLabel.font = Font.Default.Title.withSize(22)
        rootViewController.navigationItem.titleView = titleLabel
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = Color.Default.Tint.NavigationBar
        navigationBar.barTintColor = Color.Default.Background.NavigationBar
        navigationBar.backgroundColor = Color.Default.Background.NavigationBar
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    @objc
    func openSettings() {
        let viewController = SettingsViewController()
        let nav = NTNavigationViewController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
}
