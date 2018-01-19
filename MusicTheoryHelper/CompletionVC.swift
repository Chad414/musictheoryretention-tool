//
//  CompletionVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 10/11/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CompletionVC: UIViewController {
    var finalScore: Int = 0
    var optionsIndex: Int = 0
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var interstitial: GADInterstitial!
    var adShown: Bool = false
    
    @IBAction func quitButton(_ sender: UIButton) {
        // Return to menu here
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func restartButton(_ sender: UIButton) {
        // Pop current view controller off navigation controller stack
        var optionsView: UIViewController?
        let viewControllers: [UIViewController] = (self.navigationController?.viewControllers)!
        switch optionsIndex {
        case 0:
            for i in viewControllers {
                if i is PianoNoteIdentificationOptionsVC {
                    optionsView = i
                }
            }
        case 1:
            for i in viewControllers {
                if i is PianoScaleIdentificationOptionsVC {
                    optionsView = i
                }
            }
        case 2:
            for i in viewControllers {
                if i is PianoChordIdentificationOptionsVC {
                    optionsView = i
                }
            }
        case 3:
            for i in viewControllers {
                if i is StaffNoteIdentificationOptionsVC {
                    optionsView = i
                }
            }
        case 4:
            for i in viewControllers {
                if i is StaffKeyIdentificationOptionsVC {
                    optionsView = i
                }
            }
        case 5:
            for i in viewControllers {
                if i is StaffChordIdentificationOptionsVC {
                    optionsView = i
                }
            }
        case 6:
            for i in viewControllers {
                if i is NoteEarTrainingOptionsVC {
                    optionsView = i
                }
            }
        case 7:
            for i in viewControllers {
                if i is ScaleEarTrainingOptionsVC {
                    optionsView = i
                }
            }
        case 8:
            for i in viewControllers {
                if i is ChordEarTrainingOptionsVC {
                    optionsView = i
                }
            }
        default:
            print("Unexpected options index: \(optionsIndex)")
        }

        guard optionsView != nil else {
            print("Couldn't find options view controller in stack")
            return
        }
        
        self.navigationController?.popToViewController(optionsView!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Results"
        
        if optionsIndex == 3 || optionsIndex == 4 {
            switch finalScore {
            case 0...8:
                headerLabel.text = "Better Luck Next Time!"
                scoreLabel.textColor = UIColor.red
            case 9...12:
                headerLabel.text = "Not Bad!"
            case 13...16:
                headerLabel.text = "Well Done!"
            default:
                headerLabel.text = "Something's wrong here..."
                headerLabel.textColor = UIColor.red
            }
        } else {
            switch finalScore {
            case 0...15:
                headerLabel.text = "Better Luck Next Time!"
                scoreLabel.textColor = UIColor.red
            case 16...20:
                headerLabel.text = "Not Bad!"
            case 20...24:
                headerLabel.text = "Well Done!"
            default:
                headerLabel.text = "Something's wrong here..."
                headerLabel.textColor = UIColor.red
            }
        }
        
        scoreLabel.text = "Score: \(finalScore)"
        
    }
}
