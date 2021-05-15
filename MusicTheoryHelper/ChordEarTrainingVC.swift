//
//  ChordEarTrainingVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 12/2/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class ChordEarTrainingVC: UIViewController, AVAudioPlayerDelegate {
    var pianoAudioURL: [NSDataAsset] = [
        NSDataAsset(name: "C_Major_Sample")!, NSDataAsset(name: "C#_Major_Sample")!, NSDataAsset(name: "D_Major_Sample")!,
        NSDataAsset(name: "D#_Major_Sample")!, NSDataAsset(name: "E_Major_Sample")!, NSDataAsset(name: "F_Major_Sample")!,
        NSDataAsset(name: "F#_Major_Sample")!, NSDataAsset(name: "G_Major_Sample")!, NSDataAsset(name: "G#_Major_Sample")!,
        NSDataAsset(name: "A_Major_Sample")!, NSDataAsset(name: "A#_Major_Sample")!, NSDataAsset(name: "B_Major_Sample")!,
        NSDataAsset(name: "C_Minor_Sample")!, NSDataAsset(name: "C#_Minor_Sample")!, NSDataAsset(name: "D_Minor_Sample")!,
        NSDataAsset(name: "D#_Minor_Sample")!, NSDataAsset(name: "E_Minor_Sample")!, NSDataAsset(name: "F_Minor_Sample")!,
        NSDataAsset(name: "F#_Minor_Sample")!, NSDataAsset(name: "G_Minor_Sample")!, NSDataAsset(name: "G#_Minor_Sample")!,
        NSDataAsset(name: "A_Minor_Sample")!, NSDataAsset(name: "A#_Minor_Sample")!, NSDataAsset(name: "B_Minor_Sample")!,
        NSDataAsset(name: "C_Aug_Sample")!, NSDataAsset(name: "C#_Aug_Sample")!, NSDataAsset(name: "D_Aug_Sample")!,
        NSDataAsset(name: "D#_Aug_Sample")!, NSDataAsset(name: "E_Aug_Sample")!, NSDataAsset(name: "F_Aug_Sample")!,
        NSDataAsset(name: "F#_Aug_Sample")!, NSDataAsset(name: "G_Aug_Sample")!, NSDataAsset(name: "G#_Aug_Sample")!,
        NSDataAsset(name: "A_Aug_Sample")!, NSDataAsset(name: "A#_Aug_Sample")!, NSDataAsset(name: "B_Aug_Sample")!,
        NSDataAsset(name: "C_Dim_Sample")!, NSDataAsset(name: "C#_Dim_Sample")!, NSDataAsset(name: "D_Dim_Sample")!,
        NSDataAsset(name: "D#_Dim_Sample")!, NSDataAsset(name: "E_Dim_Sample")!, NSDataAsset(name: "F_Dim_Sample")!,
        NSDataAsset(name: "F#_Dim_Sample")!, NSDataAsset(name: "G_Dim_Sample")!, NSDataAsset(name: "G#_Dim_Sample")!,
        NSDataAsset(name: "A_Dim_Sample")!, NSDataAsset(name: "A#_Dim_Sample")!, NSDataAsset(name: "B_Dim_Sample")!,
    ]
    
//    var interstitial: GADInterstitial!
    var adShown: Bool = false
    let displayAD = arc4random_uniform(18)
    
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
    
    var audioPlayer: AVAudioPlayer!
    var chords: [Int] = Array(0...47) // 12 major chords, 12 minor chrords, 12 augmented chords, 12 diminished chords
    var chordsToPlay: [Int] = []
    var numberOfQuestions: Int = 24
    var playAugAndDim: Bool = false // This means play melodic minor too
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
    
    @IBOutlet var leftMajorConst: NSLayoutConstraint!
    @IBOutlet var leftAugConst: NSLayoutConstraint!
    @IBOutlet var rightMinorConst: NSLayoutConstraint!
    @IBOutlet var rightDimConst: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalSettings.deviceIs129InchiPad() {
            leftMajorConst.constant = 384
            leftAugConst.constant = 360
            rightMinorConst.constant = 384
            rightDimConst.constant = 360
        } else if GlobalSettings.deviceIs97InchiPad() {
            leftMajorConst.constant = 256
            leftAugConst.constant = 226
            rightMinorConst.constant = 246
            rightDimConst.constant = 226
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4468715439448322/1124230249")
//        let request = GADRequest()
//        interstitial.load(request)
        
        navigationItem.title = "Chord Ear Training"
        progressLabel.text = "Progress: 1/\(numberOfQuestions)"
        scoreLabel.text = "Score: 0/\(numberOfQuestions)"
        
        if playAugAndDim {
            chordsToPlay = chords
            chordsToPlay.shuffle()
        } else {
            chordsToPlay = Array(0...23)
            harmonicButton.isHidden = true
            melodicButton.isHidden = true
            chordsToPlay.shuffle()
        }
        
        buttons = [majorButton, minorButton, harmonicButton, melodicButton]
        
        // Play first chord
        do {
            audioPlayer = try AVAudioPlayer(data: pianoAudioURL[chordsToPlay[progress]].data, fileTypeHint: "mp3")
            try AVAudioSession.sharedInstance().setCategory(.ambient)
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
    @IBOutlet var playAugAndDim: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "start"?:
            let destinationViewController = segue.destination as! ChordEarTrainingVC
            destinationViewController.playAugAndDim = playAugAndDim.isOn
        default:
            print("Unexpected segue selected")
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
