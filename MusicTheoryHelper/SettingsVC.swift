//
//  SettingsVC.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 10/25/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    let emailURL: URL! = URL(string: "mailto:feedback@chadhamdan.me")
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.cellIndex = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.settingLabel?.text = "Note Names"
            cell.accessoryType = .disclosureIndicator
            cell.cellSwitch.isHidden = true
        case 1:
            cell.settingLabel?.text = "Play Sound"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        case 2:
            cell.settingLabel?.text = "Feedback or Report a Bug"
            cell.accessoryType = .disclosureIndicator
            cell.cellSwitch.isHidden = true
        case 3:
            cell.settingLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.settingLabel?.text = "About Music Theory Retention"
            cell.accessoryType = .disclosureIndicator
            cell.cellSwitch.isHidden = true
        default:
            print("Trying to display invalid cell, wrong int returned in delegate function")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "NoteNames", sender: self)
        case 1:
            tableView.cellForRow(at: indexPath)?.isSelected = false
        case 2:
            //performSegue(withIdentifier: "Feedback", sender: self)
            tableView.cellForRow(at: indexPath)?.isSelected = false
            UIApplication.shared.open(emailURL)
        case 3:
            performSegue(withIdentifier: "About", sender: self)
        default:
            print("Unknown cell selected")
        }
    }
    
}

class NoteNamesVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 48
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteNamesCell", for: indexPath)
        
        func processNoteNames(array: [String]) -> String {
            var text: String = ""
            var counter: Int = 0
            for i in array {
                if counter < 11 {
                    text = text + i + ", "
                } else {
                    text = text + i
                }
                counter += 1
            }
            return text
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = processNoteNames(array: GlobalSettings.noteNames1)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            if GlobalSettings.noteNameOption == 0 {
                cell.accessoryType = .checkmark
            }
        case 1:
            cell.textLabel?.text = processNoteNames(array: GlobalSettings.noteNames2)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            if GlobalSettings.noteNameOption == 1 {
                cell.accessoryType = .checkmark
            }
        default:
            print("Trying to display invalid cell, wrong int returned in delegate function")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch indexPath.row {
        case 0:
            GlobalSettings.noteNameOption = 0
            UserDefaults.standard.set(0, forKey: "noteNameOption")
            cell?.accessoryType = .checkmark
        case 1:
            GlobalSettings.noteNameOption = 1
            UserDefaults.standard.set(1, forKey: "noteNameOption")
            cell?.accessoryType = .checkmark
        default:
            print("Unknown cell selected")
        }
        navigationController?.popViewController(animated: true)
    }
}
