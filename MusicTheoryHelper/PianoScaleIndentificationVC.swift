//
//  PianoScaleIndentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 9/26/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class PianoScaleIndentificationVC: UIViewController {
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C3")!,
        NSDataAsset(name: "C#3")!,
        NSDataAsset(name: "D3")!,
        NSDataAsset(name: "D#3")!,
        NSDataAsset(name: "E3")!,
        NSDataAsset(name: "F3")!,
        NSDataAsset(name: "F#3")!,
        NSDataAsset(name: "G3")!,
        NSDataAsset(name: "G#3")!,
        NSDataAsset(name: "A3")!,
        NSDataAsset(name: "A#3")!,
        NSDataAsset(name: "B3")!,
        ]
    
    var scalesToDisplay: [Int] = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11] // Order will be randomized
    var scaleIsMajor: Bool = true
    var progress: Int = 0 {
        didSet {
            if scaleIsMajor {
                pianoImageView.image = UIImage(named: "PianoGraphic" + String(scalesToDisplay[progress]) + ".png")
            } else {
                pianoImageView.image = UIImage(named: "PianoGraphic" + String(scalesToDisplay[progress]) + "_m" + ".png")
            }
        }
    }
    
    @IBAction func note1(_ sender: UIButton) {
        print("\(1) Pressed")
    }
    @IBAction func note2(_ sender: UIButton) {
        print("\(2) Pressed")
    }
    @IBAction func note3(_ sender: UIButton) {
        print("\(3) Pressed")
    }
    @IBAction func note4(_ sender: UIButton) {
        print("\(4) Pressed")
    }
    @IBAction func note5(_ sender: UIButton) {
        print("\(6) Pressed")
    }
    @IBAction func note6(_ sender: UIButton) {
        print("\(6) Pressed")
    }
    @IBAction func note7(_ sender: UIButton) {
        print("\(7) Pressed")
    }
    @IBAction func note8(_ sender: UIButton) {
        print("\(8) Pressed")
    }
    @IBAction func note9(_ sender: UIButton) {
        print("\(9) Pressed")
    }
    @IBAction func note10(_ sender: UIButton) {
        print("\(10) Pressed")
    }
    @IBAction func note11(_ sender: UIButton) {
        print("\(11) Pressed")
    }
    @IBAction func note12(_ sender: UIButton) {
        print("\(12) Pressed")
    }
    @IBOutlet var note1Button: UIButton!
    @IBOutlet var note2Button: UIButton!
    @IBOutlet var note3Button: UIButton!
    @IBOutlet var note4Button: UIButton!
    @IBOutlet var note5Button: UIButton!
    @IBOutlet var note6Button: UIButton!
    @IBOutlet var note7Button: UIButton!
    @IBOutlet var note8Button: UIButton!
    @IBOutlet var note9Button: UIButton!
    @IBOutlet var note10Button: UIButton!
    @IBOutlet var note11Button: UIButton!
    @IBOutlet var note12Button: UIButton!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var pianoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Scale Note Identification"
        scoreLabel.text = "Score: 0/\(scalesToDisplay.count)"
        
        // Randomize order in which scale will be displayed
        //scalesToDisplay.shuffle()
        
        // Update image view to display firt scale
        if scaleIsMajor {
            pianoImageView.image = UIImage(named: "PianoGraphic" + String(scalesToDisplay[progress]) + ".png")
        } else {
            pianoImageView.image = UIImage(named: "PianoGraphic" + String(scalesToDisplay[progress]) + "_m" + ".png")
        }
    }
    
    func processInput(scale: Int) {
        guard (progress + 1) < scalesToDisplay.count else {
            print("Session should of ended, no more notes to display")
            return
        }
        
        if scale == scalesToDisplay[progress] {
            // Correct scale was selected
        } else {
            // Incorrect scale was selected
        }
        
        if (progress + 1) == scalesToDisplay.count {
            // End session
        } else {
            // Update score label
        }
        
    }
}

class PianoScaleIndentificationOptionsVC: UIViewController {
    
}

class PianoScaleIndentificationCompletionVC: UIViewController {
    
}
