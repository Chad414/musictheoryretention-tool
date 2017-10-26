//
//  NoteEarTrainingVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 10/17/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class NoteEarTrainingVC: UIViewController, AVAudioPlayerDelegate {
    
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C3")!, NSDataAsset(name: "C#3")!, NSDataAsset(name: "D3")!,
        NSDataAsset(name: "D#3")!, NSDataAsset(name: "E3")!, NSDataAsset(name: "F3")!,
        NSDataAsset(name: "F#3")!, NSDataAsset(name: "G3")!, NSDataAsset(name: "G#3")!,
        NSDataAsset(name: "A3")!, NSDataAsset(name: "A#3")!, NSDataAsset(name: "B3")!,
        /*NSDataAsset(name: "C2")!, NSDataAsset(name: "C#2")!, NSDataAsset(name: "D2")!,
        NSDataAsset(name: "D#2")!, NSDataAsset(name: "E2")!, NSDataAsset(name: "F2")!,
        NSDataAsset(name: "F#2")!, NSDataAsset(name: "G2")!, NSDataAsset(name: "G#2")!,
        NSDataAsset(name: "A2")!, NSDataAsset(name: "A#2")!, NSDataAsset(name: "B2")!,
        NSDataAsset(name: "C4")!, NSDataAsset(name: "C#4")!, NSDataAsset(name: "D4")!,
        NSDataAsset(name: "D#4")!, NSDataAsset(name: "E4")!, NSDataAsset(name: "F4")!,
        NSDataAsset(name: "F#4")!, NSDataAsset(name: "G4")!, NSDataAsset(name: "G#4")!,
        NSDataAsset(name: "A4")!, NSDataAsset(name: "A#4")!, NSDataAsset(name: "B4")!,*/
        ]
    
    var audioPlayer = AVAudioPlayer()
    let notes: [Int] = Array(0...35) // 12 notes, 3 octaves - 3rd = (0...11) 2nd = (12...23), 4th = (24...35)
    var notesToPlay: [Int] = [] // Determine notes to be played in viewDidLoad()
    var thirdOctaveOnly: Bool = true
    var userIsResponder: Bool = false {
        didSet {
            print("User Is Responder: \(userIsResponder)")
        }
    }
    var audioIsPlaying: Bool = true
    var progress: Int = 0 {
        didSet {
            if (progress + 1) > numberOfQuestions {
                performSegue(withIdentifier: "completion", sender: self)
                return
            }
            
            progressLabel.text = "Progress: \(progress + 1)/\(numberOfQuestions)"
            
            referenceNotePlayed = true
            
            userIsResponder = true
        }
    }
    var numberOfQuestions: Int = 24
    var correctAnswers: Int = 0
    var referenceNoteIndex: Int = 0 // Default is C3
    var referenceNotePlayed: Bool = false
    
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
    @IBAction func note8(_ sender: UIButton) {
        print("\(8) Pressed")
        if userIsResponder {
            processInput(note: 7)
        }
    }
    @IBAction func note9(_ sender: UIButton) {
        print("\(9) Pressed")
        if userIsResponder {
            processInput(note: 8)
        }
    }
    @IBAction func note10(_ sender: UIButton) {
        print("\(10) Pressed")
        if userIsResponder {
            processInput(note: 9)
        }
    }
    @IBAction func note11(_ sender: UIButton) {
        print("\(11) Pressed")
        if userIsResponder {
            processInput(note: 10)
        }
    }
    @IBAction func note12(_ sender: UIButton) {
        print("\(12) Pressed")
        if userIsResponder {
            processInput(note: 11)
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
    
    @IBAction func referenceNoteButtonAction(_ sender: Any) {
        if userIsResponder {
            userIsResponder = false
            playReferenceNote()
        }
    }
    @IBAction func currentNoteButtonAction(_ sender: Any) {
        if userIsResponder {
            userIsResponder = false
            playCurrentNote()
        }
    }
    @IBOutlet var referenceNoteButton: UIButton!
    @IBOutlet var currentNoteButton: UIButton!
    
    @IBOutlet var referenceNoteLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Note Ear Training"
        
        // Determine what notes to play
        if thirdOctaveOnly {
            notesToPlay = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11]
            //notesToPlay.shuffle()
        } else {
            notesToPlay = notes
            //notesToPlay.shuffle()
        }
        
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        
        noteButtons = [note1Button, note2Button, note3Button, note4Button, note5Button, note6Button, note7Button, note8Button, note9Button,  note10Button, note11Button, note12Button]
        
        print("Current Note \(notesToPlay[progress])")
        
        // Play reference note and current note after using AVAudioPlayer delegate
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[referenceNoteIndex].data, fileTypeHint: "mp3")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
        audioPlayer.play()
        referenceNotePlayed = true
        
        userIsResponder = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio did finish playing")
        userIsResponder = true
        currentNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
        referenceNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
        if referenceNotePlayed {
            playCurrentNote()
            referenceNotePlayed = false
        }
    }
    
    func playCurrentNote() {
        currentNoteButton.imageView?.image = UIImage(named: "icons8-stop_filled.png")
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[notesToPlay[progress]].data, fileTypeHint: "mp3")
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    func playReferenceNote() {
        referenceNoteButton.imageView?.image = UIImage(named: "icons8-stop_filled.png")
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[referenceNoteIndex].data, fileTypeHint: "mp3")
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    func animateFeedback(answer correct: Bool, selectedButtonIndex: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.noteButtons[selectedButtonIndex].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                self.noteButtons[selectedButtonIndex].tintColor = UIColor.red
                self.scoreLabel.textColor = UIColor.red
                // Find index of note played reguardless of octave and highlight green
            }
        }) { (finished: Bool) in
            UIView.animate(withDuration: 1.25, animations: {
                self.noteButtons[selectedButtonIndex].tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                    // Find index of note played reguardless of octave
                }
            }, completion: { (finished: Bool) in
                // Completion of second animation
                self.progress += 1
                self.audioPlayer.stop()
                self.playReferenceNote()
            })
        }
    }
    
    func processInput(note: Int) {
        userIsResponder = false
        
        // Play selected note
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[note].data, fileTypeHint: "mp3")
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
        audioPlayer.play()
        
        func correctAnswerSelected(_ correct: Bool) {
            if correct {
                print("Correct Note Selected!")
                correctAnswers += 1
                scoreLabel.text = "Score: \(correctAnswers)/\(notesToPlay.count)"
            }
            animateFeedback(answer: correct, selectedButtonIndex: note)
        }
        
        let notePlayed = notesToPlay[progress]
        
        switch notePlayed {
        case 0,12,24:
            if note == 0 { // C
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 1,13,25:
            if note == 1 { // C#
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 2,14,26:
            if note == 2 { // D
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 3,15,27:
            if note == 3 { // D#
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 4,16,28:
            if note == 4 { // E
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 5,17,29:
            if note == 5 { // F
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 6,18,30:
            if note == 6 { // F#
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 7,19,31:
            if note == 7 { // G
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 8,20,32:
            if note == 8 { // G#
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 9,21,33:
            if note == 9 { // A
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 10,22,34:
            if note == 10 { // A#
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        case 11,23,35:
            if note == 11 { // B
                correctAnswerSelected(true)
            } else {
                correctAnswerSelected(false)
            }
        default:
            print("Unexpected note index played")
        }
    }
    
}

class NoteEarTrainingOptionsVC: UIViewController {
    
    var referenceNote: Int = 0 {
        didSet {
            if referenceNote < 0 || referenceNote > 35 {
                print("Reference note out of range")
                referenceNote = 0
            }
        }
    }
    
    @IBOutlet var referenceNoteSlider: UISlider!
    @IBOutlet var thirdOctaveOnlySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referenceNoteSlider.maximumValue = 35
        referenceNoteSlider.minimumValue = 0
        referenceNoteSlider.value = 0
    }
    
}


