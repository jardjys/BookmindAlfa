//
//  BookSearchViewCell.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 27/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit

class BookSearchViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgCover: UIImageView!
    @IBOutlet weak var mainCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Label Style
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        authorLabel.font = UIFont(name:"Montserrat", size: 12)
        
        titleLabel.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
