//
//  OBE2ViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 19/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit

class OBE2ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        secondaryLabel.font = UIFont(name: "Montserrat",size: 20)
        mainLabel.font = UIFont(name: "Montserrat-Bold", size: 25)
        thirdLabel.font = UIFont(name: "Montserrat", size: 18)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
