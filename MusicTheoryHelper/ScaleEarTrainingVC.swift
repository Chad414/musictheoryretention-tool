//
//  ScaleEarTraining.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 11/20/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation

class ScaleEarTrainingVC: UIViewController, AVAudioPlayerDelegate {
    
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
    let notes: [Int] = Array(0...47) // 12 major scales, 12 minor scales, 12 harmonic minor, 12 melodic minor
    var scalesToPlay: [Int] = [] // Determine notes to be played in viewDidLoad()
    var playHarmonicMinor: Bool = true // This means play melodic minor too
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
            print("Next Note: \(scalesToPlay[progress])")
            
            userIsResponder = true
        }
    }
    var numberOfQuestions: Int = 24
    var correctAnswers: Int = 0
    
    @IBOutlet var majorScaleButton: UIButton!
    @IBOutlet var minorScaleButton: UIButton!
    @IBOutlet var harmonicScaleButton: UIButton!
    @IBOutlet var melodicScaleButton: UIButton!
    var noteButtons: [UIButton] = []
    
    @IBAction func majorScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            
        }
    }
    @IBAction func minorScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            
        }
    }
    @IBAction func harmonicScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            
        }
    }
    @IBAction func melodicScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            
        }
    }
    
    @IBAction func currentNoteButtonAction(_ sender: UIButton) {
        if userIsResponder {
            userIsResponder = false
            playCurrentNote()
        }
    }
    
    @IBOutlet var currentNoteButton: UIButton!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Scale Ear Training"
        
        // Determine what notes to play
        if playHarmonicMinor {
            scalesToPlay = Array(0...23)
            scalesToPlay.shuffle()
        } else {
            scalesToPlay = notes
            scalesToPlay.shuffle()
        }
        
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        
        noteButtons = [majorScaleButton, minorScaleButton, harmonicScaleButton, melodicScaleButton]
        
        print("Current Note \(scalesToPlay[progress])")
        
        // Play current scale
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[scalesToPlay[progress]].data, fileTypeHint: "mp3")
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
        currentNoteButton.imageView?.image = UIImage(named: "icons8-stop_filled.png")
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[scalesToPlay[progress]].data, fileTypeHint: "mp3")
            audioPlayer.delegate = self
        } catch {
            print(error)
        }
        audioPlayer.play()
    }
    
    func animateFeedback(answer correct: Bool, selectedButtonIndex: Int) {
        // Force any outstanding layout changes
        view.layoutIfNeeded()
        
        let correctButtonIndex: Int = self.findNoteIndex(self.scalesToPlay[progress])
        
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
                    //self.playReferenceNote()
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
                scoreLabel.text = "Score: \(correctAnswers)/\(scalesToPlay.count)"
            }
            animateFeedback(answer: correct, selectedButtonIndex: note)
        }
        
        if findNoteIndex(scalesToPlay[progress]) == findNoteIndex(note) {
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
            destinationViewController.optionsIndex = 7
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

class ScaleEarTrainingOptionsVC: UIViewController {
    
}
