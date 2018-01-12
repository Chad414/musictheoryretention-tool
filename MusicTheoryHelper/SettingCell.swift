//
//  SettingCell.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 1/11/18.
//  Copyright © 2018 Chad Hamdan. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    @IBOutlet var settingLabel: UILabel!
    @IBOutlet var cellSwitch: UISwitch! {
        didSet {
            if GlobalSettings.playAudio {
                cellSwitch.isOn = true
            } else {
                cellSwitch.isOn = false
            }
        }
    }
    var cellIndex: Int = 0
    
    @IBAction func cellSwitchAction(_ sender: UISwitch) {
        if cellIndex == 1 {
            if sender.isOn {
                GlobalSettings.playAudio = true
                UserDefaults.standard.set(true, forKey: "playAudio")
            } else {
                GlobalSettings.playAudio = false
                UserDefaults.standard.set(false, forKey: "playAudio")
            }
        }
    }
    
    override func prepareForReuse() {
        self.contentView.addSubview(settingLabel)
        self.contentView.addSubview(cellSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
