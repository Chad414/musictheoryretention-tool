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
        NSDataAsset(name: "C2")!, NSDataAsset(name: "C#2")!, NSDataAsset(name: "D2")!,
        NSDataAsset(name: "D#2")!, NSDataAsset(name: "E2")!, NSDataAsset(name: "F2")!,
        NSDataAsset(name: "F#2")!, NSDataAsset(name: "G2")!, NSDataAsset(name: "G#2")!,
        NSDataAsset(name: "A2")!, NSDataAsset(name: "A#2")!, NSDataAsset(name: "B2")!,
        NSDataAsset(name: "C4")!, NSDataAsset(name: "C#4")!, NSDataAsset(name: "D4")!,
        NSDataAsset(name: "D#4")!, NSDataAsset(name: "E4")!, NSDataAsset(name: "F4")!,
        NSDataAsset(name: "F#4")!, NSDataAsset(name: "G4")!, NSDataAsset(name: "G#4")!,
        NSDataAsset(name: "A4")!, NSDataAsset(name: "A#4")!, NSDataAsset(name: "B4")!,
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
            print("Next Note: \(notesToPlay[progress])")
            
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
    
    @IBAction func referenceNoteButtonAction(_ sender: UIButton) {
        if userIsResponder {
            userIsResponder = false
            playReferenceNote()
        }
    }
    @IBAction func currentNoteButtonAction(_ sender: UIButton) {
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
            notesToPlay.shuffle()
        } else {
            notesToPlay = notes
            notesToPlay.shuffle()
        }
        
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        referenceNoteLabel.text = "Refence Note: \(referenceNoteDictionary[referenceNoteIndex] ?? "C3")"
        
        noteButtons = [note1Button, note2Button, note3Button, note4Button, note5Button, note6Button, note7Button, note8Button, note9Button,  note10Button, note11Button, note12Button]
        
        for i in noteButtons {
            i.setTitle(GlobalSettings.noteNames[noteButtons.index(of: i)!], for: .normal)
        }
        
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
        currentNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
        referenceNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
        if referenceNotePlayed {
            guard progress <= 24 else {
                return
            }
            playCurrentNote()
            referenceNotePlayed = false
        } else {
            userIsResponder = true
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
        
        let correctButtonIndex: Int = self.findNoteIndex(self.notesToPlay[progress])
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.noteButtons[selectedButtonIndex].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                self.noteButtons[selectedButtonIndex].tintColor = UIColor.red
                self.scoreLabel.textColor = UIColor.red
                self.noteButtons[correctButtonIndex].tintColor = UIColor.green
            }
        }) { (finished: Bool) in
            UIView.animate(withDuration: 1.25, animations: {
                self.noteButtons[selectedButtonIndex].tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                    self.noteButtons[correctButtonIndex].tintColor = UIColor.appleBlue()
                }
            }, completion: { (finished: Bool) in
                // Completion of second animation
                self.progress += 1
                self.audioPlayer.stop()
                if self.progress < 24 {
                    self.playReferenceNote()
                }
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
        
        if findNoteIndex(notesToPlay[progress]) == findNoteIndex(note) {
            correctAnswerSelected(true)
        } else {
            correctAnswerSelected(false)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "completion"?:
            let destinationViewController = segue.destination as! CompletionVC
            destinationViewController.finalScore = self.correctAnswers
            destinationViewController.optionsIndex = 6
        default:
            print("Unexpected segue selected")
        }
    }
    
    func findNoteIndex(_ note: Int) -> Int {
        switch note {
        case 0,12,24:
            return 0 // C
        case 1,13,25:
            return 1 // C#
        case 2,14,26:
            return 2 // D
        case 3,15,27:
            return 3 // D#
        case 4,16,28:
            return 4 // E
        case 5,17,29:
            return 5 // F
        case 6,18,30:
            return 6 // F#
        case 7,19,31:
            return 7 // G
        case 8,20,32:
            return 8 // G#
        case 9,21,33:
            return 9 // A
        case 10,22,34:
            return 10 // A#
        case 11,23,35:
            return 11 // B
        default:
            print("Unexpected note index")
            return 0
        }
    }
}

let referenceNoteDictionary: [Int:String] = [
    0 : "C3", 1 : "C#3", 2 : "D3", 3 : "D#3", 4 : "E3", 5 : "F3", 6 : "F#3", 7 : "G3",
    8 : "G#3", 9 : "A3", 10 : "A#3", 11 : "B3", 12 : "C2", 13 : "C#2", 14 : "D2", 15 : "D#2",
    16 : "E2", 17 : "F2", 18 : "F#2", 19 : "G2", 20 : "G#2", 21 : "A2", 22 : "A#2", 23 : "B2",
    24 : "C4", 25 : "C#4", 26 : "D4", 27 : "D#4", 28 : "E4", 29 : "F4", 30 : "F#4", 31 : "G4",
    32 : "G#4", 33 : "A4", 34 : "A#4", 35 : "B4"]

class NoteEarTrainingOptionsVC: UIViewController {
    
    var referenceNote: Int = 0 {
        didSet {
            if referenceNote < 0 || referenceNote > 35 {
                print("Reference note out of range")
                referenceNote = 0
            }
            print("Reference Note Changed to: \(referenceNote)")
        }
    }
    
    @IBAction func referenceNoteChanged(_ sender: UISlider) {
        sender.value = floorf(sender.value + 0.5)
        referenceNote = Int(sender.value)
        referenceNoteLabel.text = referenceNoteDictionary[referenceNote]
    }
    
    @IBOutlet var referenceNoteLabel: UILabel!
    @IBOutlet var referenceNoteSlider: UISlider!
    @IBOutlet var thirdOctaveOnlySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referenceNoteSlider.maximumValue = 35
        referenceNoteSlider.minimumValue = 0
        referenceNoteSlider.value = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! NoteEarTrainingVC
            destinationViewController.referenceNoteIndex = referenceNote
            destinationViewController.thirdOctaveOnly = thirdOctaveOnlySwitch.isOn
        default:
            print("Unexpected segue selected")
        }
    }
    
}


