//
//  ListTableViewCell.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 28/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var imageBg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Label Style
        listNameLabel.font = UIFont(name: "Montserrat-Bold", size: 20)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
