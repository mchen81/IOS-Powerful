//
//  SingleSetTVCell.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/5.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import SwipeCellKit

class SingleSetTVCell: SwipeTableViewCell{

    @IBOutlet weak var SetNumberLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    @IBOutlet weak var weightTextField: TVCellTextField!
    @IBOutlet weak var repsTextField: TVCellTextField!
    
    @IBOutlet weak var isDoneImage: UIImageView!
    
    var buttonDelegate: SwipeTableViewCellDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}



