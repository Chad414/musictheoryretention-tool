//
//  PianoScaleIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 9/26/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class PianoScaleIdentificationVC: UIViewController {
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
    
    var audioPlayer = AVAudioPlayer()
    var scalesToDisplay: [Int] = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11] // Order will be randomized
    var scaleIsMajor: Bool = true
    let minorGraphicsIndex: [Int] = [3, 4, 5, 11, 7, 8, 9, 10, 6, 0, 1, 2]
    var progress: Int = 0 {
        didSet {
            if (progress + 1) > scalesToDisplay.count {
                performSegue(withIdentifier: "completion", sender: self)
                return
            }
            if scaleIsMajor {
                pianoImageView.image = UIImage(named: "PianoScaleGraphic" + String(scalesToDisplay[progress]) + ".png")
            } else {
                print("Minor Index: \(minorGraphicsIndex[scalesToDisplay[progress]])")
                pianoImageView.image = UIImage(named: "PianoScaleGraphic" + String(minorGraphicsIndex[scalesToDisplay[progress]]) + ".png")
            }
            progressLabel.text = "Progress: \(progress + 1)/\(scalesToDisplay.count)"
            userIsResponder = true
        }
    }
    
    var userIsResponder: Bool = false
    var correctAnswers: Int = 0
    
    @IBAction func note1(_ sender: UIButton) {
        print("\(1) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 0)
        }
    }
    @IBAction func note2(_ sender: UIButton) {
        print("\(2) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 1)
        }
    }
    @IBAction func note3(_ sender: UIButton) {
        print("\(3) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 2)
        }
    }
    @IBAction func note4(_ sender: UIButton) {
        print("\(4) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 3)
        }
    }
    @IBAction func note5(_ sender: UIButton) {
        print("\(6) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 4)
        }
    }
    @IBAction func note6(_ sender: UIButton) {
        print("\(6) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 5)
        }
    }
    @IBAction func note7(_ sender: UIButton) {
        print("\(7) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 6)
        }
    }
    @IBAction func note8(_ sender: UIButton) {
        print("\(8) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 7)
        }
    }
    @IBAction func note9(_ sender: UIButton) {
        print("\(9) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 8)
        }
    }
    @IBAction func note10(_ sender: UIButton) {
        print("\(10) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 9)
        }
    }
    @IBAction func note11(_ sender: UIButton) {
        print("\(11) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 10)
        }
    }
    @IBAction func note12(_ sender: UIButton) {
        print("\(12) Pressed")
        if userIsResponder {
            userIsResponder = false
            processInput(scale: 11)
        }
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
    var noteButtons: [UIButton] = []
    
    @IBOutlet var scaleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var pianoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Piano Scale Identification"
        if scaleIsMajor {
            scaleLabel.text = "Scale: Major"
        } else {
            scaleLabel.text = "Scale: Minor"
        }
        progressLabel.text = "Progress: 1/\(scalesToDisplay.count)"
        scoreLabel.text = "Score: 0/\(scalesToDisplay.count)"
        
        noteButtons = [note1Button, note2Button, note3Button, note4Button, note5Button, note6Button, note7Button, note8Button, note9Button,  note10Button, note11Button, note12Button]
        
        // Randomize order in which scale will be displayed
        scalesToDisplay.shuffle()
        
        // Update image view to display firt scale
        if scaleIsMajor {
            pianoImageView.image = UIImage(named: "PianoScaleGraphic" + String(scalesToDisplay[progress]) + ".png")
        } else {
            print("Minor Index: \(minorGraphicsIndex[scalesToDisplay[progress]])")
            pianoImageView.image = UIImage(named: "PianoScaleGraphic" + String(minorGraphicsIndex[scalesToDisplay[progress]]) + ".png")
        }
        
        userIsResponder = true
        print("Current Displayed Scale: \(scalesToDisplay[progress])")
        
        // Load audio here
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[scalesToDisplay[progress]].data, fileTypeHint: "mp3")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
    }
    
    func processInput(scale: Int) {
        
        // Play audio here
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[scale].data, fileTypeHint: "mp3")
        } catch {
            print(error)
        }
        audioPlayer.play()
        
        
        if scale == scalesToDisplay[progress] {
            // Correct scale was selected
            print("Correct Scale Selected!")
            animateFeedback(answer: true, buttonIndex: scale)
            correctAnswers += 1
            scoreLabel.text = "Score: \(correctAnswers)/\(scalesToDisplay.count)"
        } else {
            // Incorrect scale was selected
            print("Incorrect Scale Selected!")
            animateFeedback(answer: false, buttonIndex: scale)
        }
        
        print("Current Displayed Scale: \(scalesToDisplay[progress])")
        
    }
    
    func animateFeedback(answer correct: Bool, buttonIndex: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.noteButtons[buttonIndex].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                self.noteButtons[buttonIndex].tintColor = UIColor.red
                self.noteButtons[self.scalesToDisplay[self.progress]].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.red
            }
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.75, animations: {
                self.noteButtons[buttonIndex].tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                self.noteButtons[self.scalesToDisplay[self.progress]].tintColor = UIColor.appleBlue()
                }
            }, completion: { (finished: Bool) in
                // Completion of second animation
                self.progress += 1
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "completion"?:
            let destinationViewController = segue.destination as! CompletionVC
            destinationViewController.finalScore = correctAnswers
            destinationViewController.optionsIndex = 1
        default:
            print("Unexpected segue selected")
        }
    }
    
}

class PianoScaleIdentificationOptionsVC: UIViewController {
    var scaleIsMajor: Bool = true
    
    @IBAction func changedScale(_ sender: UISegmentedControl) {
        print("Segmented Control:   \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            scaleIsMajor = true
        } else if sender.selectedSegmentIndex == 1 {
            scaleIsMajor = false
        } else {
            print("Unexpected segue selected")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! PianoScaleIdentificationVC
            destinationViewController.scaleIsMajor = scaleIsMajor
        default:
            print("Unexpected segue selected")
        }
    }
}
