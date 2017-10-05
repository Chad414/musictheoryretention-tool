//
//  MainMenuTableViewController.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 8/8/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit

class MainMenuTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBOutlet var settingsButton: UIBarButtonItem!
    
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
    
}
