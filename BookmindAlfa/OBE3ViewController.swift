//
//  OBE3ViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 19/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit

class OBE3ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        secondaryLabel.font = UIFont(name: "Montserrat",size: 20)
        mainLabel.font = UIFont(name: "Montserrat-Bold", size: 25)
        thirdLabel.font = UIFont(name: "Montserrat", size: 18)
        startButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        startButton.layer.borderWidth = 2
        startButton.layer.cornerRadius = startButton.frame.height/2
        startButton.layer.borderColor = UIColor(white: 1, alpha: 0.5).CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action to click of button
    @IBAction func onClick(sender: AnyObject) {
        presentController("mainSign")
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func presentController(storyboardId: String) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardId)
        self.presentViewController(controller!, animated: true, completion: nil)
    }

}
