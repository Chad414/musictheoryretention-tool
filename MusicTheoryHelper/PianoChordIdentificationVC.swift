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
    var chordsToDisplay: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23] // Order will be randomized, only indicies 0..23 will be shown
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
        
        //chordsToDisplay.shuffle()
        
        pianoImageView.image = UIImage(named: "PianoChordGraphic" + String(chordsToDisplay[progress]) + ".png")
        
        userIsResponder = true
        
    }
    
    func processInput(button: Int) {
        let chordDisplayed = chordsToDisplay[progress]
        
        func correctAnswerSelected() {
            print("Correct Chord Type Selected!")
            // Animate feedback here
            correctAnswers += 1
            scoreLabel.text = "Score: \(correctAnswers)/\(numberOfQuestions)"
        }
        
        switch button {
        case 0:
            if chordDisplayed <= 11 {
                // Correct answer because all chords 0...11 are major
                correctAnswerSelected()
            } else {
                // Incorrect answer
            }
        case 1:
            if chordDisplayed >= 12 && chordDisplayed <= 23 {
                // Correct answer because all chords 12...23 are minor
                correctAnswerSelected()
            } else {
                // Incorrect answer
            }
        case 2:
            print("Augmented chord range not determined yet")
        case 3:
            print("Diminished chord range not determined yet")
        default:
            print("Unexpected button pressed")
        }
        
    }
    
}
