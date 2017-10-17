//
//  PianoChordIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 10/11/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class PianoChordIdentificationVC: UIViewController {
    
    @IBAction func majorButtonAction(_ sender: UIButton) {
        print("Major Button Pressed!")
        if userIsResponder {
            userIsResponder = false
            processInput(button: 0)
        }
    }
    @IBAction func minorButtonAction(_ sender: UIButton) {
        print("Minor Button Pressed!")
        if userIsResponder {
            userIsResponder = false
            processInput(button: 1)
        }
    }
    @IBAction func augmentedButtonPressed(_ sender: UIButton) {
        print("Augmented Button Pressed!")
        if userIsResponder {
            userIsResponder = false
            processInput(button: 2)
        }
    }
    @IBAction func diminishedButtonPressed(_ sender: UIButton) {
        print("Diminished Button Pressed!")
        if userIsResponder {
            userIsResponder = false
            processInput(button: 3)
        }
    }
    
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var augmentedButton: UIButton!
    @IBOutlet var diminishedButton: UIButton!
    @IBOutlet var pianoImageView: UIImageView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    var buttons: [UIButton] = []
    var chordsToDisplay: [Int] = Array(0...38) // Order will be randomized, only indicies 0..23 will be shown
    var userIsResponder: Bool = false
    var correctAnswers: Int = 0
    var numberOfQuestions = 24
    var progress: Int = 0 {
        didSet {
            if (progress + 1) > numberOfQuestions {
                performSegue(withIdentifier: "completion", sender: self)
                return
            }
            pianoImageView.image = UIImage(named: "PianoChordGraphic" + String(chordsToDisplay[progress]) + ".png")
            progressLabel.text = "Progress: \(progress + 1)/\(numberOfQuestions)"
            userIsResponder = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Piano Chord Identification"
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        
        buttons = [majorButton, minorButton, augmentedButton, diminishedButton]
        
        chordsToDisplay.shuffle()
        
        pianoImageView.image = UIImage(named: "PianoChordGraphic" + String(chordsToDisplay[progress]) + ".png")
        
        userIsResponder = true
        
    }
    
    func processInput(button: Int) {
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
            if chordDisplayed <= 9 {
                // Correct answer because all chords 0...9 are major
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 1:
            if chordDisplayed >= 10 && chordDisplayed <= 19 {
                // Correct answer because all chords 12...23 are minor
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 2:
            if chordDisplayed >= 20 && chordDisplayed <= 27 {
                // Correct answer because all chords 20...29 are augmented
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 3:
            if chordDisplayed >= 28 && chordDisplayed <= 38 {
                // Correct answer because all chords 20...29 are augmented
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
                self.progress += 1
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "completion"?:
            let destinationViewController = segue.destination as! CompletionVC
            destinationViewController.finalScore = correctAnswers
            destinationViewController.optionsIndex = 2
        default:
            print("Unexpected segue selected")
        }
    }
    
}

class PianoChordIdentificationOptionsVC: UIViewController {
    
}
