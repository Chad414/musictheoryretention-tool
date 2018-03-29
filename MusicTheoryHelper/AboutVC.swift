//
//  AboutVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 1/11/18.
//  Copyright © 2018 Chad Hamdan. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet var imageLongPressGesture: UILongPressGestureRecognizer!
    
    @IBAction func icons8Link(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://icons8.com")!)
    }
    @IBOutlet var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageLongPressGesture.minimumPressDuration = 8.0
        
        versionLabel.text = "Version: \(GlobalSettings.version)"
    }
    
    @IBAction func imageGestureTriggered(_ sender: Any) {
        print("Secret profile photo gesture was triggered")
        
        if GlobalSettings.showAds == false {
            return
        }
        
        GlobalSettings.chadHamdan = true
    }
    
}


