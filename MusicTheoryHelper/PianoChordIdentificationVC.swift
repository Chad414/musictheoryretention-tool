//
//  PianoChordIndentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 9/11/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class PianoChordIdentificationVC: UIViewController {
    
    @IBAction func majorButtonAction(_ sender: UIButton) {
    }
    @IBAction func minorButtonAction(_ sender: UIButton) {
    }
    @IBAction func augmentedButtonPressed(_ sender: UIButton) {
    }
    @IBAction func diminishedButtonPressed(_ sender: UIButton) {
    }
    
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var augmentedButton: UIButton!
    @IBOutlet var diminishedButton: UIButton!
    @IBOutlet var pianoImageView: UIImageView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    var buttons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [majorButton, minorButton, augmentedButton, diminishedButton]

    }
    
}
