//
//  SingleSetCell.swift
//  Powerful
//
//  Created by 陳孟澤 on 2020/6/9.
//  Copyright © 2020 Jerry Chen. All rights reserved.
//

import UIKit
import SwipeCellKit

class SingleSetCell: SwipeTableViewCell {

    @IBOutlet weak var SetNumberLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var doneImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


