//
//  StaffKeyIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 11/8/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class StaffKeyIdentificationVC: UIViewController {
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
    
    @IBAction func note3(_ sender: UIButton) {
        print("\(0) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[0], position: 0)
        }
    }
    @IBAction func note4(_ sender: UIButton) {
        print("\(1) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[1], position: 1)
        }
    }
    @IBAction func note5(_ sender: UIButton) {
        print("\(2) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[2], position: 2)
        }
    }
    @IBAction func note6(_ sender: UIButton) {
        print("\(3) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[3], position: 3)
        }
    }
    @IBAction func note7(_ sender: UIButton) {
        print("\(4) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[4], position: 4)
        }
    }
    @IBAction func note8(_ sender: UIButton) {
        print("\(5) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[5], position: 5)
        }
    }
    @IBAction func note9(_ sender: UIButton) {
        print("\(6) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[6], position: 6)
        }
    }
    @IBAction func note10(_ sender: UIButton) {
        print("\(7) Pressed")
        if userIsResponder {
            processInput(note: buttonOrder[7], position: 7)
        }
    }
    @IBOutlet var note3Button: UIButton!
    @IBOutlet var note4Button: UIButton!
    @IBOutlet var note5Button: UIButton!
    @IBOutlet var note6Button: UIButton!
    @IBOutlet var note7Button: UIButton!
    @IBOutlet var note8Button: UIButton!
    @IBOutlet var note9Button: UIButton!
    @IBOutlet var note10Button: UIButton!

    var noteButtons: [UIButton] = []
    
    var actualNoteIndex: Int {
        switch signaturesToDisplay[progress] {
        case 0,8:
            return 0
        case 1,9:
            return 1
        case 2,10:
            return 2
        case 3,11:
            return 3
        case 4,12:
            return 4
        case 5,13:
            return 5
        case 6,14:
            return 6
        case 7,15:
            return 7
        default:
            print("Unexpected note index")
            return 0
        }
    }
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var pianoImageView: UIImageView!
    @IBOutlet var scaleLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    // Display 16 signatures because there are 8 per clef
    var signaturesToDisplay: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] // Order will be randomized
    var buttonOrder: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    var graphicsArray: [String] = []
    var progress: Int = 0 {
        didSet {
            if (progress + 1) > signaturesToDisplay.count {
                performSegue(withIdentifier: "completion", sender: self)
                return
            }
            
            progressLabel.text = "Progress: \(progress + 1)/\(signaturesToDisplay.count)"
            
            pianoImageView.image = UIImage(named: graphicsArray[signaturesToDisplay[progress]])
            
            userIsResponder = true
        }
    }
    var correctAnswers: Int = 0
    var userIsResponder: Bool = false
    var configuration: Int = 0 // 0 = Major, Sharp; 1 = Major, Flat; 2 = Minor, Sharp; 3 = Minor, Flat;
    var displaySharpGraphics: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Staff Key Identification"
        progressLabel.text = "Progress: 1/\(signaturesToDisplay.count)"
        scoreLabel.text = "Score: 0/\(signaturesToDisplay.count)"
        
        noteButtons = [note3Button, note4Button, note5Button, note6Button, note7Button, note8Button, note9Button,  note10Button]
        
        buttonOrder.shuffle()
        
        func assignButtonLabels(labels: [String]) {
            var labelPositionIndex = 0
            for i in noteButtons {
                i.setTitle(labels[buttonOrder[labelPositionIndex]], for: .normal)
                labelPositionIndex += 1
            }
        }
        
        // Configure UI based on options here
        switch configuration {
        case 0:
            // Sharp, Major
            displaySharpGraphics = true
            scaleLabel.text = "Scale: Major"
            // Define buttons labels as string array
            let buttonLabels = ["C", "G", "D", "A", "E", "B", "F#", "C#"]
            // Loop through each button using defined labels
            assignButtonLabels(labels: buttonLabels)
        case 1:
            // Flat, Major
            displaySharpGraphics = false
            scaleLabel.text = "Scale: Major"
            let buttonLabels = ["C", "F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb"]
            assignButtonLabels(labels: buttonLabels)
        case 2:
            // Sharp, Minor
            displaySharpGraphics = true
            scaleLabel.text = "Scale: Minor"
            let buttonLabels = ["A", "E", "B", "F#", "C#", "G#", "D#", "A#"]
            assignButtonLabels(labels: buttonLabels)
        case 3:
            // Flat, Minor
            displaySharpGraphics = false
            scaleLabel.text = "Scale: Minor"
            let buttonLabels = ["A", "D", "G", "C", "F", "Bb", "Eb", "Ab"]
            assignButtonLabels(labels: buttonLabels)
        default:
            print("Unknown configuration selected in options menu")
        }
        
        // Populate graphics array based on scale configuration
        // This must be done before signatures are shuffled so graphics array can be referenced properly
        if displaySharpGraphics {
            for i in signaturesToDisplay {
                graphicsArray.append("SharpKeyGraphic" + "\(i)" + ".png")
            }
        } else {
            for i in signaturesToDisplay {
                graphicsArray.append("FlatKeyGraphic" + "\(i)" + ".png")
            }
        }
        
        signaturesToDisplay.shuffle()
        print(signaturesToDisplay)
        print(graphicsArray)
        
        pianoImageView.image = UIImage(named: graphicsArray[signaturesToDisplay[progress]])
        
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[actualNoteIndex].data, fileTypeHint: "mp3")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        userIsResponder = true
    }
    
    func processInput(note: Int, position: Int) {
        userIsResponder = false
        
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[note].data, fileTypeHint: "mp3")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        if note == actualNoteIndex {
            // Correct answer selected
            print("Correct Key Signature Selected!")
            correctAnswers += 1
            scoreLabel.text = "Score: \(correctAnswers)/\(signaturesToDisplay.count)"
            animateFeedback(answer: true, buttonIndex: note, position: position)
        } else {
            print("Incorrect Key Signature Selected!")
            animateFeedback(answer: false, buttonIndex: note, position: position)
        }
    }
    
    func animateFeedback(answer correct: Bool, buttonIndex: Int, position: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        let indexOfCorrectButton: Int = self.buttonOrder.index(of: actualNoteIndex) ?? 0
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.noteButtons[position].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                self.noteButtons[position].tintColor = UIColor.red
                self.noteButtons[indexOfCorrectButton].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.red
            }
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.75, animations: {
                self.noteButtons[position].tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                    self.noteButtons[indexOfCorrectButton].tintColor = UIColor.appleBlue()
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
            destinationViewController.optionsIndex = 4
        default:
            print("Unexpected segue selected")
        }
    }
}

class StaffKeyIdentificationOptionsVC: UIViewController {
    var signatureIsSharp: Bool = true
    var scaleIsMajor: Bool = true
    
    @IBAction func signatureChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            signatureIsSharp = true
        } else if selectedIndex == 1 {
            signatureIsSharp = false
        }
    }
    
    @IBAction func scaleChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            scaleIsMajor = true
        } else if selectedIndex == 1 {
            scaleIsMajor = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! StaffKeyIdentificationVC
            
            if signatureIsSharp && scaleIsMajor {
                destinationViewController.configuration = 0
            } else if !signatureIsSharp && scaleIsMajor {
                destinationViewController.configuration = 1
            } else if signatureIsSharp && !scaleIsMajor {
                destinationViewController.configuration = 2
            } else if !signatureIsSharp && !scaleIsMajor {
                destinationViewController.configuration = 3
            }
        default:
            print("Unexpected segue identifier")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
