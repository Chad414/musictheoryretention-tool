//
//  ScaleEarTraining.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 11/20/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class ScaleEarTrainingVC: UIViewController, AVAudioPlayerDelegate {
    
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C_Major")!, NSDataAsset(name: "C#_Major")!, NSDataAsset(name: "D_Major")!,
        NSDataAsset(name: "D#_Major")!, NSDataAsset(name: "E_Major")!, NSDataAsset(name: "F3")!,
        NSDataAsset(name: "F#_Major")!, NSDataAsset(name: "G_Major")!, NSDataAsset(name: "G#_Major")!,
        NSDataAsset(name: "A_Major")!, NSDataAsset(name: "A#_Major")!, NSDataAsset(name: "B_Major")!,
        NSDataAsset(name: "C_Minor")!, NSDataAsset(name: "C#_Minor")!, NSDataAsset(name: "D_Minor")!,
        NSDataAsset(name: "D#_Minor")!, NSDataAsset(name: "E_Minor")!, NSDataAsset(name: "F_Minor")!,
        NSDataAsset(name: "F#_Minor")!, NSDataAsset(name: "G_Minor")!, NSDataAsset(name: "G#_Minor")!,
        NSDataAsset(name: "A_Minor")!, NSDataAsset(name: "A#_Minor")!, NSDataAsset(name: "B_Minor")!,
        NSDataAsset(name: "C_hMinor")!, NSDataAsset(name: "C#_hMinor")!, NSDataAsset(name: "D_hMinor")!,
        NSDataAsset(name: "D#_hMinor")!, NSDataAsset(name: "E_hMinor")!, NSDataAsset(name: "F_hMinor")!,
        NSDataAsset(name: "F#_hMinor")!, NSDataAsset(name: "G_hMinor")!, NSDataAsset(name: "G#_hMinor")!,
        NSDataAsset(name: "A_hMinor")!, NSDataAsset(name: "A#_hMinor")!, NSDataAsset(name: "B_hMinor")!,
        NSDataAsset(name: "C_mMinor")!, NSDataAsset(name: "C#_mMinor")!, NSDataAsset(name: "D_mMinor")!,
        NSDataAsset(name: "D#_mMinor")!, NSDataAsset(name: "E_mMinor")!, NSDataAsset(name: "F_mMinor")!,
        NSDataAsset(name: "F#_mMinor")!, NSDataAsset(name: "G_mMinor")!, NSDataAsset(name: "G#_mMinor")!,
        NSDataAsset(name: "A_mMinor")!, NSDataAsset(name: "A#_mMinor")!, NSDataAsset(name: "B_mMinor")!,
    ]
    
//    var interstitial: GADInterstitial!
    var adShown: Bool = false
    let displayAD = arc4random_uniform(18)
    
    var audioPlayer: AVAudioPlayer!
    let notes: [Int] = Array(0...47) // 12 major scales, 12 minor scales, 12 harmonic minor, 12 melodic minor
    var scalesToPlay: [Int] = [] // Determine notes to be played in viewDidLoad()
    var playHarmonicMinor: Bool = false // This means play melodic minor too
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
            processInput(note: 0)
        }
    }
    @IBAction func minorScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 1)
        }
    }
    @IBAction func harmonicScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 2)
        }
    }
    @IBAction func melodicScaleButtonAction(_ sender: UIButton) {
        if userIsResponder {
            processInput(note: 3)
        }
    }
    
    @IBAction func currentNoteButtonAction(_ sender: UIButton) {
        playCurrentNote()
    }
    
    @IBOutlet var currentNoteButton: UIButton!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4468715439448322/2628883602")
//        let request = GADRequest()
//        interstitial.load(request)
        
        navigationItem.title = "Scale Ear Training"
        
        // Determine what notes to play
        if playHarmonicMinor {
            scalesToPlay = notes
            scalesToPlay.shuffle()
        } else {
            scalesToPlay = Array(0...23)
            harmonicScaleButton.isHidden = true
            melodicScaleButton.isHidden = true
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
        if audioPlayer.isPlaying {
            OperationQueue.main.addOperation {
                self.currentNoteButton.imageView?.image = UIImage(named: "icons8-play_filled.png")
            }
            audioPlayer.stop()
        } else {
            currentNoteButton.imageView?.image = UIImage(named: "icons8-stop_filled.png")
            do {
                audioPlayer = try AVAudioPlayer(data: pianoAudioURL[scalesToPlay[progress]].data, fileTypeHint: "mp3")
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
//                if self.interstitial.isReady && self.adShown == false && GlobalSettings.showAds == true {
//                    if self.progress == self.displayAD {
//                        self.interstitial.present(fromRootViewController: self)
//                        self.adShown = true
//                    }
//                } else {
//                    print("Ad wasn't ready")
//                }
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
        
        if findNoteIndex(scalesToPlay[progress]) == note {
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
    @IBOutlet var playHarmonicMinor: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! ScaleEarTrainingVC
            destinationViewController.playHarmonicMinor = playHarmonicMinor.isOn
        default:
            print("Unexpected segue selected")
        }
    }
}
