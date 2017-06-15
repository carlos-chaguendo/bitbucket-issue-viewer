//
//  FlowCard.swift
//  IssueViewer
//
//  Created by carlos chaguendo on 15/06/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit

@IBDesignable
class FlowCard: UIViewFromXIB {
    
    @IBInspectable var textColor: UIColor? = UIColor.black
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var userlabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lineSeparatorVieew: UIView!
    
    @IBOutlet weak var bangasLabel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userlabel.textColor = textColor
        userLocationLabel.textColor = textColor
        bangasLabel.textColor = textColor
        rollLabel.textColor = textColor
        startLabel.textColor = textColor
        
        lineSeparatorVieew.backgroundColor = textColor?.withAlphaComponent(0.3)
    }

}
