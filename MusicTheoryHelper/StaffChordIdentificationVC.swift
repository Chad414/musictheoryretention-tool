//
//  StaffChordIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 12/2/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StaffChordIdentificationVC: UIViewController {
    
    var interstitial: GADInterstitial!
    var adShown: Bool = false
    let displayAD = arc4random_uniform(18)
    
    @IBAction func majorButtonPressed(_ sender: UIButton) {
        print("Major Button Pressed!")
        if userIsResponder {
            processInput(button: 0)
        }
    }
    @IBAction func minorButtonPressed(_ sender: UIButton) {
        print("Minor Button Pressed!")
        if userIsResponder {
            processInput(button: 1)
        }
    }
    @IBAction func augmentedButtonPressed(_ sender: UIButton) {
        print("Augmented Button Pressed!")
        if userIsResponder {
            processInput(button: 2)
        }
    }
    @IBAction func diminishedButtonPressed(_ sender: UIButton) {
        print("Diminished Button Pressed!")
        if userIsResponder {
            processInput(button: 3)
        }
    }
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var augmentedButton: UIButton!
    @IBOutlet var diminishedButton: UIButton!
    @IBOutlet var staffImageView: UIImageView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    // Constraints
    @IBOutlet var bottomRightConst: NSLayoutConstraint!
    @IBOutlet var bottomLeftConst: NSLayoutConstraint!
    
    var chordsToDisplay: [Int] = Array(0...38) // Order will be randomized, only indicies 0..23 will be shown
    var graphics: [String] = []
    var displayTrebleClef: Bool = false
    var userIsResponder: Bool = false
    var correctAnswers: Int = 0
    var numberOfQuestions: Int = 24
    var progress: Int = 0 {
        didSet {
            if (progress + 1) > numberOfQuestions {
                performSegue(withIdentifier: "completion", sender: self)
                return
            }
            staffImageView.image = UIImage(named: graphics[chordsToDisplay[progress]])
            progressLabel.text = "Progress: \(progress + 1)/\(numberOfQuestions)"
            userIsResponder = true
        }
    }
    var buttons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalSettings.displayIsCompact() {
            bottomLeftConst.constant = 32
            bottomRightConst.constant = 32
        }
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4468715439448322/6021333701")
        
        let request = GADRequest()
        interstitial.load(request)
        
        if displayTrebleClef {
            var array: [String] = []
            for i in 0...47 {
                array.append("TrebleChordGraphic\(i).png")
            }
            graphics = array
        } else {
            var array: [String] = []
            for i in 0...47 {
                array.append("BassChordGraphic\(i).png")
            }
            graphics = array
        }
        
        navigationItem.title = "Staff Chord Identification"
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        
        buttons = [majorButton, minorButton, augmentedButton, diminishedButton]
        
        chordsToDisplay.shuffle()
        
        staffImageView.image = UIImage(named: graphics[chordsToDisplay[progress]])
        
        userIsResponder = true
    }
    
    func processInput(button: Int) {
        userIsResponder = false
        let chordDisplayed = chordsToDisplay[progress]
        
        func correctAnswerSelected(_ correct: Bool) {
            if correct {
                print("Correct Chord Type Selected!")
                correctAnswers += 1
                scoreLabel.text = "Score: \(correctAnswers)/\(numberOfQuestions)"
            }
            animateFeedback(answer: correct, selectedButtonIndex: button)
        }
        
        switch button {
        case 0:
            if chordDisplayed <= 11 {
                // Correct answer because all chords 0...11 are major
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 1:
            if chordDisplayed >= 12 && chordDisplayed <= 23 {
                // Correct answer because all chords 12...23 are minor
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 2:
            if chordDisplayed >= 24 && chordDisplayed <= 35 {
                // Correct answer because all chords 24...35 are augmented
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 3:
            if chordDisplayed >= 28 && chordDisplayed <= 38 {
                // Correct answer because all chords 36...47 are diminished
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        default:
            print("Unexpected button pressed")
        }
    }
    
    func animateFeedback(answer correct: Bool, selectedButtonIndex: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        var correctButtonIndex: Int {
            switch self.chordsToDisplay[progress] {
            case 0...9:
                return 0
            case 10...19:
                return 1
            case 20...27:
                return 2
            case 28...38:
                return 3
            default:
                print("Unexpected chord displayed")
                return 1
            }
        }
        
        let selectedButton = self.buttons[selectedButtonIndex]
        let correctButton = self.buttons[correctButtonIndex]
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                selectedButton.tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                selectedButton.tintColor = UIColor.red
                correctButton.tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.red
            }
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.75, animations: {
                selectedButton.tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                    correctButton.tintColor = UIColor.appleBlue()
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
            destinationViewController.optionsIndex = 5
        default:
            print("Unexpected segue selected")
        }
    }
    
}

class StaffChordIdentificationOptionsVC: UIViewController {
    
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
            let destinationViewController = segue.destination as! StaffChordIdentificationVC
            destinationViewController.displayTrebleClef = displayTrebleClef
        default:
            print("Unexpected segue selected")
        }
    }
    
}
