//
//  MenuCell.swift
//  MusicTheoryHelper
//
//  Created by Chad Hamdan on 10/4/17.
//  Copyright © 2017 Chad Hamdan. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet var iconView: UIImageView!
    
    
    func updateIconView(image: UIImage?) {
        self.contentView.addSubview(iconView)
        if let icon = image {
            iconView.image = icon
        } else {
            iconView.image = nil
        }
        
        if GlobalSettings.deviceIsiPad() {
            if GlobalSettings.deviceIs129InchiPad() {
                self.textLabel?.font = self.textLabel?.font.withSize(26.0)
            } else {
                self.textLabel?.font = self.textLabel?.font.withSize(22.0)
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateIconView(image: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateIconView(image: nil)
    }

}
