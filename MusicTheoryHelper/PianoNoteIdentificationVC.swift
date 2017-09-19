//
//  PianoNoteIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 8/12/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class PianoNoteIdentificationVC: UIViewController {
    
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C3")!]
    
    var audioPlayer = AVAudioPlayer()
    // Each note should be displayed twice per session, order will be randomized later.
    var notesToDisplay: [Int] = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11] // Order will be randomized
    var noteButtonOrder: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] // Order will be randomized
    var progress: Int = 0 {
        didSet {
            // Display next note here
            self.pianoImageView.image = UIImage(named: "PianoGraphic" + String(notesToDisplay[progress]) + ".png")
            self.userIsResponder = true
            // Play next note here with AVFoundation
        }
    }
    var userIsResponder: Bool = false
    var correctAnswers: Int = 0
    var randomizeButtons: Bool = true
    
    // There must be a total of 12 buttons for each note
    // Use button number for button order index
    @IBAction func note1(_ sender: UIButton) {
        print("\(noteButtonOrder[0]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[0], buttonIndex: 0)
        }
    }
    @IBAction func note2(_ sender: UIButton) {
        print("\(noteButtonOrder[1]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[1], buttonIndex: 1)
        }
    }
    @IBAction func note3(_ sender: UIButton) {
        print("\(noteButtonOrder[2]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[2], buttonIndex: 2)
        }
    }
    @IBAction func note4(_ sender: UIButton) {
        print("\(noteButtonOrder[3]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[3], buttonIndex: 3)
        }
    }
    @IBAction func note5(_ sender: UIButton) {
        print("\(noteButtonOrder[4]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[4], buttonIndex: 4)
        }
    }
    @IBAction func note6(_ sender: UIButton) {
        print("\(noteButtonOrder[5]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[5], buttonIndex: 5)
        }
    }
    @IBAction func note7(_ sender: UIButton) {
        print("\(noteButtonOrder[6]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[6], buttonIndex: 6)
        }
    }
    @IBAction func note8(_ sender: UIButton) {
        print("\(noteButtonOrder[7]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[7], buttonIndex: 7)
        }
    }
    @IBAction func note9(_ sender: UIButton) {
        print("\(noteButtonOrder[8]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[8], buttonIndex: 8)
        }
    }
    @IBAction func note10(_ sender: UIButton) {
        print("\(noteButtonOrder[9]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[9], buttonIndex: 9)
        }
    }
    @IBAction func note11(_ sender: UIButton) {
        print("\(noteButtonOrder[10]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[10], buttonIndex: 10)
        }
    }
    @IBAction func note12(_ sender: UIButton) {
        print("\(noteButtonOrder[11]) Pressed")
        if userIsResponder {
            userIsResponder = false
            proccessNoteButtonAction(note: noteButtonOrder[11], buttonIndex: 11)
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
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var pianoImageView: UIImageView!
    var noteButtons: [UIButton] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Piano Note Identification"
        scoreLabel.text = "Progress: 0/\(notesToDisplay.count)"
        
        // Randomize placement of butons
        if randomizeButtons {
            noteButtonOrder.shuffle()
            
            //print("Randomized Button Order: \(noteButtonOrder)")
            noteButtons = [note1Button, note2Button, note3Button, note4Button, note5Button, note6Button, note7Button, note8Button, note9Button,  note10Button, note11Button, note12Button]
            var noteStringsToDisplay: [String] = []
            
            
            for i in noteButtonOrder {
                noteStringsToDisplay.append(GlobalSettings.noteNames1[i])
            }
            print("Note Strings: \(noteStringsToDisplay)")
            
            var noteCounter = 0
            for i in noteButtons {
                i.setTitle(noteStringsToDisplay[noteCounter], for: .normal)
                noteCounter += 1
            }
            
        }
        
        // Randomize notes array here
        notesToDisplay.shuffle()
        print("Notes to display: \(notesToDisplay)")
        print("Current Displayed Note: \(notesToDisplay[progress])")
        
        // Display first note here, further progress will be handled by button actions
        //pianoImageView.image = UIImage(named: "PianoGraphic.png")
        pianoImageView.image = UIImage(named: "PianoGraphic" + String(notesToDisplay[progress]) + ".png")
        
        userIsResponder = true
        
        // Should audio be loaded here?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
    }
    
    func proccessNoteButtonAction(note: Int, buttonIndex: Int) {
        // Process specific note passed here
        
        print("Note \(note) Selected!")
        
        guard (progress + 1) < notesToDisplay.count else {
            print("Session should of ended, no more notes to display")
            return
        }
        
        // Play selected note here with AVFoundation
        // Test is loading the audio file here is fast enough on a real device
        /*do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[notesToDisplay[progress]].data, fileTypeHint: "mp3")
        } catch {
            print(error)
        }
        audioPlayer.play()*/
        
        // Check if it's correct and change score value that will update score label
        // Note passed will be compared to current note being shown from the notes array
        if note == notesToDisplay[progress] {
            // The correct note was selected
            animateFeedback(answer: true, buttonIndex: buttonIndex)
            print("Correct Note Selected")
            correctAnswers += 1
        } else {
            // The incorrect note was selected
            animateFeedback(answer: false, buttonIndex: buttonIndex)
            print("Incorrect note selected")
        }
        
        // Also check notes array progress, once all notes have been shown, end session
        if (progress + 1) == notesToDisplay.count {
            // End session
            // Perform segue here and pass score to destination view controller
        } else {
            scoreLabel.text = "Progress: \(correctAnswers)/\(notesToDisplay.count)"
        }
        
        print("Current Displayed Note: \(notesToDisplay[progress])")
        
    }
    
    func animateFeedback(answer correct: Bool, buttonIndex: Int) {
        // Force any outstanding lauout changes
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.noteButtons[buttonIndex].tintColor = UIColor.green
            } else {
                self.noteButtons[buttonIndex].tintColor = UIColor.red
            }
        }, completion: { (finished: Bool) in
            self.progress += 1
            UIView.animate(withDuration: 1.0, animations: {
                self.noteButtons[buttonIndex].tintColor = UIColor.appleBlue()
            }, completion: { (finished: Bool) in
                // Completion of second animation
            })
        })
    }
    
}

class PianoNoteIdentificationOptionsVC: UIViewController {
    @IBOutlet var randomizeButtons: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! PianoNoteIdentificationVC
            destinationViewController.randomizeButtons = randomizeButtons.isOn
        default:
            print("Unexpected segue selected")
        }
    }
}
