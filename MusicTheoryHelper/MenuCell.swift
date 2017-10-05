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
