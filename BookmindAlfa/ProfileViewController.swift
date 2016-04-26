//
//  ProfileViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 22/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    var iduser = String()
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Setting up the profile picture

        let query = PFUser.query()
        query!.getObjectInBackgroundWithId(iduser) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                self.nameLabel.text = user!["name"] as? String
                self.countryLabel.text = user!["country"]as? String
                let userImage = user!["profilepicture"] as! PFFile
                userImage.getDataInBackgroundWithBlock{(imageData: NSData?, error: NSError?) -> Void in
                    if error ==  nil {
                        self.profPic.image = UIImage(data: imageData!)
                    }
                }
            } else {
                print(error)
            }
            
        }
        
        //Profile Picture style
        profPic.layer.cornerRadius = profPic.frame.height/1.75
        profPic.clipsToBounds = true
        
        //Label Style
        nameLabel.font = UIFont(name: "Montserrat-Bold", size: 20)
        countryLabel.font = UIFont(name:"Montserrat", size: 14)
        
        //Menu settings button
        let menuimg = UIImage(named: "Settings.png")
        menuButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        menuButton.setImage(menuimg, forState: UIControlState.Normal)
        
        //Search button
        let searchimg = UIImage(named: "Search.png")
        searchButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        searchButton.setImage(searchimg, forState: UIControlState.Normal)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuPressed(sender: AnyObject) {
        print("menupressed")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC : SettingsViewController = segue.destinationViewController as! SettingsViewController
        if let useridsegue: String = self.iduser {
            destinationVC.userid = useridsegue
        }
    }
}
