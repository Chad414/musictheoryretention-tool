//
//  ChordEarTrainingVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 12/2/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class ChordEarTrainingVC: UIViewController, AVAudioPlayerDelegate {
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C_Major")!, NSDataAsset(name: "C#_Major")!, NSDataAsset(name: "D_Major")!,
        NSDataAsset(name: "D#_Major")!, NSDataAsset(name: "E_Major")!, NSDataAsset(name: "F3")!,
        NSDataAsset(name: "F#_Major")!, NSDataAsset(name: "G_Major")!, NSDataAsset(name: "G#_Major")!,
        NSDataAsset(name: "A_Major")!, NSDataAsset(name: "A#_Major")!, NSDataAsset(name: "B_Major")!,
        NSDataAsset(name: "C_Minor")!, NSDataAsset(name: "C#_Minor")!, NSDataAsset(name: "D_Minor")!,
        NSDataAsset(name: "D#_Minor")!, NSDataAsset(name: "E_Minor")!, NSDataAsset(name: "F_Minor")!,
        NSDataAsset(name: "F#_Minor")!, NSDataAsset(name: "G_Minor")!, NSDataAsset(name: "G#_Minor")!,
        NSDataAsset(name: "A_Minor")!, NSDataAsset(name: "A#_Minor")!, NSDataAsset(name: "B_Minor")!,
        NSDataAsset(name: "C_Aug")!, NSDataAsset(name: "C#_Aug")!, NSDataAsset(name: "D_Aug")!,
        NSDataAsset(name: "D#_Aug")!, NSDataAsset(name: "E_Aug")!, NSDataAsset(name: "F_Aug")!,
        NSDataAsset(name: "F#_Aug")!, NSDataAsset(name: "G_Aug")!, NSDataAsset(name: "G#_Aug")!,
        NSDataAsset(name: "A_Aug")!, NSDataAsset(name: "A#_Aug")!, NSDataAsset(name: "B_Aug")!,
        NSDataAsset(name: "C_Dim")!, NSDataAsset(name: "C#_Dim")!, NSDataAsset(name: "D_Dim")!,
        NSDataAsset(name: "D#_Dim")!, NSDataAsset(name: "E_Dim")!, NSDataAsset(name: "F_Dim")!,
        NSDataAsset(name: "F#_Dim")!, NSDataAsset(name: "G_Dim")!, NSDataAsset(name: "G#_Dim")!,
        NSDataAsset(name: "A_Dim")!, NSDataAsset(name: "A#_Dim")!, NSDataAsset(name: "B_Dim")!,
    ]
    
    @IBAction func majorButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 0)
        }
    }
    @IBAction func minorButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 1)
        }
    }
    @IBAction func harmonicButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 2)
        }
    }
    @IBAction func melodicButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 3)
        }
    }
    
    @IBAction func currentNoteButtonAction(_ sender: UIButton) {
        playCurrentNote()
    }
    
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var harmonicButton: UIButton!
    @IBOutlet var melodicButton: UIButton!
    var buttons: [UIButton] = []
    
    @IBOutlet var currentNoteButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    var chords: [Int] = Array(0...47) // 12 major chords, 12 minor chrords, 12 augmented chords, 12 diminished chords
    var chordsToPlay: [Int] = []
    var numberOfQuestions: Int = 24
    var playHarmonicMinor: Bool = false // This means play melodic minor too
    var correctAnswers: Int = 0
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
            print("Next Chord: \(chordsToPlay[progress])")
            
            userIsResponder = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chord Ear Training"
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        
        if playHarmonicMinor {
            chordsToPlay = chords
            //chordsToPlay.shuffle()
        } else {
            chordsToPlay = Array(0...23)
            harmonicButton.isHidden = true
            melodicButton.isHidden = true
            //chordsToPlay.shuffle()
        }
        
        buttons = [majorButton, minorButton, harmonicButton, melodicButton]
        
        // Play first chord
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[chordsToPlay[progress]].data, fileTypeHint: "mp3")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
        audioPlayer.play()
        
        userIsResponder = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio did finish playing")
        currentNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
    }
    
    func playCurrentNote() {
        if audioPlayer.isPlaying {
            OperationQueue.main.addOperation {
                self.currentNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
            }
            audioPlayer.stop()
        } else {
            currentNoteButton.imageView?.image = UIImage(named: "icons8-stop_filled.png")
            do {
                audioPlayer = try AVAudioPlayer(data: pianoAudioURL[chordsToPlay[progress]].data, fileTypeHint: "mp3")
                audioPlayer.delegate = self
            } catch {
                print(error)
            }
            audioPlayer.play()
        }
    }
    
    func animateFeedback(answer correct: Bool, selectedButtonIndex: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        let correctButtonIndex: Int = self.findNoteIndex(self.chordsToPlay[progress])
        
        UIView.animate(withDuration: 0.5, animations: {
            if correct {
                self.buttons[selectedButtonIndex].tintColor = UIColor.green
                self.scoreLabel.textColor = UIColor.green
            } else {
                self.buttons[selectedButtonIndex].tintColor = UIColor.red
                self.scoreLabel.textColor = UIColor.red
                self.buttons[correctButtonIndex].tintColor = UIColor.green
            }
        }) { (finished: Bool) in
            UIView.animate(withDuration: 1.25, animations: {
                self.buttons[selectedButtonIndex].tintColor = UIColor.appleBlue()
                self.scoreLabel.textColor = UIColor.black
                if !correct {
                    self.buttons[correctButtonIndex].tintColor = UIColor.appleBlue()
                }
            }, completion: { (finished: Bool) in
                // Completion of second animation
                self.progress += 1
                self.audioPlayer.stop()
                if self.progress < 24 {
                    self.playCurrentNote()
                }
            })
        }
    }
    
    func processInput(note: Int) {
        userIsResponder = false
        
        func correctAnswerSelected(_ correct: Bool) {
            if correct {
                print("Correct Note Selected!")
                correctAnswers += 1
                scoreLabel.text = "Score: \(correctAnswers)/\(numberOfQuestions)"
            }
            animateFeedback(answer: correct, selectedButtonIndex: note)
        }
        
        if findNoteIndex(chordsToPlay[progress]) == note {
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
            destinationViewController.optionsIndex = 8
        default:
            print("Unexpected segue selected")
        }
    }
    
    func findNoteIndex(_ note: Int) -> Int {
        switch note {
        case 0...11:
            return 0 // Major
        case 12...23:
            return 1 // Minor
        case 24...35:
            return 2 // Harmonic Minor
        case 36...47:
            return 3 // Melodic Minor
        default:
            print("Unexpected note index")
            return 0
        }
    }
    
}

class ChordEarTrainingOptionsVC: UIViewController {
    @IBOutlet var playHarmonicMinor: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! ChordEarTrainingVC
            destinationViewController.playHarmonicMinor = playHarmonicMinor.isOn
        default:
            print("Unexpected segue selected")
        }
    }
}
