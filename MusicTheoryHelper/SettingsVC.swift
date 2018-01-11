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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        
        switch indexPath.row {
        case 0:
            cell.settingLabel?.text = "Note Names"
        case 1:
            cell.settingLabel?.text = "Play Sound"
        case 2:
            cell.settingLabel?.text = "Feedback or Report a Bug"
        case 3:
            cell.settingLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            cell.settingLabel?.text = "About Music Theory Retention"
        default:
            print("Trying to display invalid cell, wrong int returned in delegate function")
        }
        return cell
    }
    
}
