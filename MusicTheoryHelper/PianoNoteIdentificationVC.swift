//
//  PianoNoteIdentificationVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 8/12/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit

class PianoNoteIdentificationVC: UIViewController {
    
    // Each note should be displayed twice per session, order will be randomized later.
    var notesToDisplay: [Int] = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11] // Order will be randomized
    var noteButtonOrder: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] // Order will be randomized
    var progress: Int = 0
    var correctAnswers: Int = 0
    
    // There must be a total of 12 buttons for each note
    // Use button number for button order index
    @IBAction func note1(_ sender: UIButton) {
        print("\(noteButtonOrder[0]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[0])
    }
    @IBAction func note2(_ sender: UIButton) {
        print("\(noteButtonOrder[1]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[1])
    }
    @IBAction func note3(_ sender: UIButton) {
        print("\(noteButtonOrder[2]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[2])
    }
    @IBAction func note4(_ sender: UIButton) {
        print("\(noteButtonOrder[3]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[3])
    }
    @IBAction func note5(_ sender: UIButton) {
        print("\(noteButtonOrder[4]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[4])
    }
    @IBAction func note6(_ sender: UIButton) {
        print("\(noteButtonOrder[5]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[5])
    }
    @IBAction func note7(_ sender: UIButton) {
        print("\(noteButtonOrder[6]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[6])
    }
    @IBAction func note8(_ sender: UIButton) {
        print("\(noteButtonOrder[7]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[7])
    }
    @IBAction func note9(_ sender: UIButton) {
        print("\(noteButtonOrder[8]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[8])
    }
    @IBAction func note10(_ sender: UIButton) {
        print("\(noteButtonOrder[9]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[9])
    }
    @IBAction func note11(_ sender: UIButton) {
        print("\(noteButtonOrder[10]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[10])
    }
    @IBAction func note12(_ sender: UIButton) {
        print("\(noteButtonOrder[11]) Pressed")
        proccessNoteButtonAction(note: noteButtonOrder[11])
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
        scoreLabel.text = "Score: 0/\(notesToDisplay.count)"
        
        // Rewrite note names on buttons based on user settings
        // Keep in mind this will need feedback from the Image View to be tested
        
        // Randomize placement of butons
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
        
        // Randomize notes array here
        notesToDisplay.shuffle()
        print("Notes to display: \(notesToDisplay)")
        print("Current Displayed Note: \(notesToDisplay[progress])")
        
        // Display first note here, further progress will be handled by button actions
        //pianoImageView.image = UIImage(named: "PianoGraphic.png")
        pianoImageView.image = UIImage(named: "PianoGraphic" + String(notesToDisplay[progress]) + ".png")
        
    }
    
    func proccessNoteButtonAction(note: Int) {
        // Process specific note passed here
        
        print("Note \(note) Selected!")
        
        guard progress < notesToDisplay.count else {
            print("Session should of ended, no more notes to display")
            return
        }
        
        // Check if it's correct and change score label, also keep track of an integer score so performance data can be used later
        // Note passed will be compared to current note being shown from the notes array
        if note == notesToDisplay[progress] {
            // The correct note was selected
            print("Correct Note Selected")
            correctAnswers += 1
        } else {
            // The incorrect note was selected
            print("Incorrect note selected")
        }
        
        // Also check notes array progress, once all notes have been shown, end session
        if progress == notesToDisplay.count {
            // End session
        } else {
            scoreLabel.text = "Score: \(correctAnswers)/\(notesToDisplay.count)"
            progress += 1
            // Display next note here
            pianoImageView.image = UIImage(named: "PianoGraphic" + String(notesToDisplay[progress]) + ".png")
        }
        
        print("Current Displayed Note: \(notesToDisplay[progress])")
        
    }
    
}
