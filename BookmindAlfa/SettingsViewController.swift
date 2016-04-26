//
//  SettingsViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 26/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    var userid = String();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Get User Data
        
        let query = PFUser.query()
        SwiftLoading().showLoading()
        query!.getObjectInBackgroundWithId(userid) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                self.nameText.text = user!["name"] as? String
                self.mailText.text = user!["email"]as? String
                let userImage = user!["profilepicture"] as! PFFile
                userImage.getDataInBackgroundWithBlock{(imageData: NSData?, error: NSError?) -> Void in
                    if error ==  nil {
                        self.profPic.image = UIImage(data: imageData!)
                        SwiftLoading().hideLoading()
                    }
                }
            } else {
                print(error)
                SwiftLoading().hideLoading()
            }
            
        }
        
        //Profile Picture style
        profPic.layer.cornerRadius = profPic.frame.height/1.75
        profPic.clipsToBounds = true
        
        //Padding for nameText
        let padding = UIView(frame: CGRectMake(0, 0, 25, nameText.frame.height))
        nameText.leftView = padding
        nameText.leftViewMode = UITextFieldViewMode.Always
        
        //nameText style
        nameText.layer.cornerRadius = nameText.frame.height/2
        nameText.attributedPlaceholder = NSAttributedString(string: "Name", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        nameText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //Padding for MailText
        let padding2 = UIView(frame: CGRectMake(0, 0, 25, mailText.frame.height))
        mailText.leftView = padding2
        mailText.leftViewMode = UITextFieldViewMode.Always
        
        //Padding for PasswordText
        let padding3 = UIView(frame: CGRectMake(0, 0, 25, mailText.frame.height))
        passwordText.leftView = padding3
        passwordText.leftViewMode = UITextFieldViewMode.Always
        
        //MailText style
        mailText.layer.cornerRadius = mailText.frame.height/2
        mailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        mailText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //PasswordText style
        passwordText.layer.cornerRadius = mailText.frame.height/2
        passwordText.attributedPlaceholder = NSAttributedString(string: "Type a new password", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //Accept button
        let doneimg = UIImage(named: "Donebutton.png")
        acceptButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        acceptButton.setImage(doneimg, forState: UIControlState.Normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}