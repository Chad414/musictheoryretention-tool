//
//  MainMenuTableViewController.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 8/8/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit

class MainMenuTableViewController: UITableViewController {
    
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet weak var purchaseButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIScreen.main.nativeBounds.height <= 1136 {
            navigationItem.title = "MTR"
        }
        
        tableView.reloadData()
    
        /*if GlobalSettings.showAds == false {
            navigationItem.rightBarButtonItem = nil
        }*/
        
        // Remove purchase button until feature is tested
        navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAPHandler.shared.purchaseStatusBlock = { [weak self] (type) in
            guard let strongSelf = self else { return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func removeAdsButton(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Purchase MTR", message: "Remove annoying pop-up ads from Music Theory Retnetion", preferredStyle: .alert)
        
        let restoreAction = UIAlertAction(title: "Restore Purchase", style: .default) { (sender) in
            print("Restoreing Purchase...")
        }
        let purchaseAction = UIAlertAction(title: "Remove Ads - $1.99", style: .cancel) { (sender) in
            print("Removing Ads...")
        }
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        
        ac.addAction(restoreAction)
        ac.addAction(purchaseAction)
        ac.addAction(closeAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        switch indexPath.section {
        case 0:
            // Display piano section
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Piano Note Identification"
            case 1:
                cell.textLabel?.text = "Piano Scale Identification"
            case 2:
                cell.textLabel?.text = "Piano Chord Identification"
            default:
                print("Trying to display unexpected table cell in first section")
            }
            OperationQueue.main.addOperation {
                cell.updateIconView(image: UIImage(named: "icons8-piano.png"))
            }
        case 1:
            // Dispaly staff section
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Staff Note Identification"
            case 1:
                cell.textLabel?.text = "Staff Key Identification"
            case 2:
                cell.textLabel?.text = "Staff Chord Identification"
            default:
                print("Trying to display unexpected table cell in second section")
            }
            OperationQueue.main.addOperation {
                cell.updateIconView(image: UIImage(named: "icons8-music_transcript.png"))
            }
        case 2:
            // Display ear section
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Note Ear Training"
            case 1:
                cell.textLabel?.text = "Scale Ear Training"
            case 2:
                cell.textLabel?.text = "Chord Ear Training"
            default:
                print("Trying to display unexpectecd table cell in third section")
            }
            OperationQueue.main.addOperation {
                cell.updateIconView(image: UIImage(named: "icons8-speaker.png"))
            }
        default:
            print("Trying to display cells in an unexpected section")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of menu options per section
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 3
        default:
            print("Unexpected numberOfRowsInSection handled")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Piano Training"
        case 1:
            return "Staff Training"
        case 2:
            return "Ear Training"
        default:
            return "Unexpected Section"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // This function must be rewirtten to work with multiple sections
        // Prepare different segue depending on what cell was selected.
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "piano1", sender: self)
            case 1:
                performSegue(withIdentifier: "piano2", sender: self)
            case 2:
                performSegue(withIdentifier: "piano3", sender: self)
            default:
                print("Unexpected cell selected")
            }
        case 1:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "staff1", sender: self)
            case 1:
                performSegue(withIdentifier: "staff2", sender: self)
            case 2:
                performSegue(withIdentifier: "staff3", sender: self)
            default:
                print("Unexpected cell seleted")
            }
        case 2:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "ear1", sender: self)
            case 1:
                performSegue(withIdentifier: "ear2", sender: self)
            case 2:
                performSegue(withIdentifier: "ear3", sender: self)
            default:
                print("Unexpected cell selected")
            }
        default:
            print("Unexpected cell selected")
        }
    }
    
    func purchaseMTR(_ sender: UIAlertAction) -> Void {
        IAPHandler.shared.purchaseProduct(index: 0)
    }
    
    @IBAction func purchaseButtonPressed(_ sender: UIBarButtonItem) {
        guard IAPHandler.shared.canMakePurchases() else {
            let message = "This Device Cannot make Purchases"
            let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            ac.addAction(closeAction)
            self.present(ac, animated: true, completion: nil)
            return
        }
        
        let message = "Remove Annoying Ads from Music Theory Retention"
        let ac = UIAlertController(title: "Remove Ads", message: message, preferredStyle: .alert)
        let purchaseAction = UIAlertAction(title: "Purchase MTR for $1.99", style: .default, handler: purchaseMTR)
        let restoreAction = UIAlertAction(title: "Restore Purchase", style: .default, handler: nil)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        ac.addAction(purchaseAction)
        ac.addAction(restoreAction)
        ac.addAction(closeAction)
        self.present(ac, animated: true, completion: nil)
        
    }
    
    
}
