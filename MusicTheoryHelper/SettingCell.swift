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
    
    override func prepareForReuse() {
        self.contentView.addSubview(settingLabel)
    }
}
