//
//  StaffNoteIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 10/26/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class StaffNoteIdentificationVC: UIViewController {
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C3")!,
        NSDataAsset(name: "D3")!,
        NSDataAsset(name: "E3")!,
        NSDataAsset(name: "F3")!,
        NSDataAsset(name: "G3")!,
        NSDataAsset(name: "A3")!,
        NSDataAsset(name: "B3")!,
        ]
    
    var interstitial: GADInterstitial!
    var adShown: Bool = false
    let displayAD = arc4random_uniform(10)
    
    @IBAction func note1(_ sender: UIButton) {
        print("\(1) Pressed")
        if userIsResponder {
            processInput(note: 0)
        }
    }
    @IBAction func note2(_ sender: UIButton) {
        print("\(2) Pressed")
        if userIsResponder {
            processInput(note: 1)
        }
    }
    @IBAction func note3(_ sender: UIButton) {
        print("\(3) Pressed")
        if userIsResponder {
            processInput(note: 2)
        }
    }
    @IBAction func note4(_ sender: UIButton) {
        print("\(4) Pressed")
        if userIsResponder {
            processInput(note: 3)
        }
    }
    @IBAction func note5(_ sender: UIButton) {
        print("\(6) Pressed")
        if userIsResponder {
            processInput(note: 4)
        }
    }
    @IBAction func note6(_ sender: UIButton) {
        print("\(6) Pressed")
        if userIsResponder {
            processInput(note: 5)
        }
    }
    @IBAction func note7(_ sender: UIButton) {
        print("\(7) Pressed")
        if userIsResponder {
            processInput(note: 6)
        }
    }
    @IBOutlet var note1Button: UIButton!
    @IBOutlet var note2Button: UIButton!
    @IBOutlet var note3Button: UIButton!
    @IBOutlet var note4Button: UIButton!
    @IBOutlet var note5Button: UIButton!
    @IBOutlet var note6Button: UIButton!
    @IBOutlet var note7Button: UIButton!
    var noteButtons: [UIButton] = []
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var pianoImageView: UIImageView!

    var audioPlayer = AVAudioPlayer()
    let playAudio = GlobalSettings.playAudio
    var notesToDisplay: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] // Order will be randomized
    var progress: Int = 0 {
        didSet {
            if (progress + 1) > notesToDisplay.count {
                performSegue(withIdentifier: "completion", sender: self)
                return
            }
            
            progressLabel.text = "Progress: \(progress + 1)/\(notesToDisplay.count)"
            
            if displayTrebleClef {
                pianoImageView.image = UIImage(named: "TrebleStaff" + "\(notesToDisplay[progress])" + ".png")
            } else {
                pianoImageView.image = UIImage(named: "BassStaff" + "\(notesToDisplay[progress])" + ".png")
            }
            
            userIsResponder = true
        }
    }
    var correctAnswers: Int = 0
    var displayTrebleClef: Bool = true
    var userIsResponder: Bool = false
    var actualNoteIndex: Int {
        switch notesToDisplay[progress] {
        case 0,7:
            return 0
        case 1,8:
            return 1
        case 2,9:
            return 2
        case 3,10:
            return 3
        case 4,11:
            return 4
        case 5,12:
            return 5
        case 6,13:
            return 6
        default:
            print("Unexpected note index")
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4468715439448322/9413783805")
        
        let request = GADRequest()
        interstitial.load(request)
        
        navigationItem.title = "Staff Note Identification"
        progressLabel.text = "Progress: 1/\(notesToDisplay.count)"
        scoreLabel.text = "Score: 0/\(notesToDisplay.count)"
        
        noteButtons = [note1Button, note2Button, note3Button, note4Button, note5Button, note6Button, note7Button]
        
        // Randomize displayed notes
        notesToDisplay.shuffle()
        
        // Update Graphic
        if displayTrebleClef {
            pianoImageView.image = UIImage(named: "TrebleStaff" + "\(actualNoteIndex)" + ".png")
        } else {
            pianoImageView.image = UIImage(named: "BassStaff" + "\(actualNoteIndex)" + ".png")
        }
        
        if playAudio {
            do {
                audioPlayer = try AVAudioPlayer(data: pianoAudioURL[actualNoteIndex].data, fileTypeHint: "mp3")
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
        }
        
        userIsResponder = true
    }
    
    func processInput(note selected: Int) {
        userIsResponder = false
        
        // Play selected note
        if playAudio {
            do {
                audioPlayer = try AVAudioPlayer(data: pianoAudioURL[selected].data, fileTypeHint: "mp3")
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            audioPlayer.play()
        }

        
        if selected == actualNoteIndex {
            // Correct Answer selected
            print("Correct Note Selected!")
            correctAnswers += 1
            scoreLabel.text = "Score: \(correctAnswers)/\(notesToDisplay.count)"
            animateFeedback(answer: true, buttonIndex: selected)
        } else {
            // Incorrect Answer Selected
            animateFeedback(answer: false, buttonIndex: selected)
        }
        
    }
    
    func animateFeedback(answer correct: Bool, buttonIndex: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        let indexOfCorrectButton = self.actualNoteIndex
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.noteButtons[buttonIndex].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                self.noteButtons[buttonIndex].tintColor = UIColor.red
                self.noteButtons[indexOfCorrectButton].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.red
            }
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.75, animations: {
                self.noteButtons[buttonIndex].tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                    self.noteButtons[indexOfCorrectButton].tintColor = UIColor.appleBlue()
                }
            }, completion: { (finished: Bool) in
                // Completion of second animation
                if self.interstitial.isReady && self.adShown == false && GlobalSettings.showAds == true {
                    if self.progress == self.displayAD {
                        self.interstitial.present(fromRootViewController: self)
                        self.adShown = true
                    }
                } else {
                    print("Ad wasn't ready")
                }
                self.progress += 1
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "completion"?:
            let destinationViewController = segue.destination as! CompletionVC
            destinationViewController.finalScore = correctAnswers
            destinationViewController.optionsIndex = 3
        default:
            print("Unexpected segue selected")
        }
    }
    
}

class StaffNoteIdentificationOptionsVC: UIViewController {
    
    var displayTrebleClef: Bool = true
    @IBAction func clefType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            displayTrebleClef = true
        } else if sender.selectedSegmentIndex == 1 {
            displayTrebleClef = false
        } else {
            print("Unexpected segue selected")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! StaffNoteIdentificationVC
            destinationViewController.displayTrebleClef = displayTrebleClef
        default:
            print("Unexpected segue selected")
        }
    }
}

