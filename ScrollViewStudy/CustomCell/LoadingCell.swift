//
//  LoadingCell.swift
//  ScrollViewStudy
//
//  Created by ByungHoon Ann on 2019/12/03.
//  Copyright © 2019 ByungHoon Ann. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
