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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    var userid = String();
    var keyboardFlag = false;
    
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
        //Label Style
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 20)
        
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
        
        //Cancel button
        let cancelimg = UIImage(named: "Cancel.png")
        cancelButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cancelButton.setImage(cancelimg, forState: UIControlState.Normal)
        
        //Hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Get frame up when keyboard comes this goes in viewdidload
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)

    }
    
    //Dismiss Keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Hide and show keyboard up
    
    func keyboardWillShow(sender: NSNotification) {
        if !keyboardFlag {
            self.view.frame.origin.y -= 150
            keyboardFlag = true
        } else {
            keyboardFlag = true
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
        keyboardFlag = false
    }
    //Accept pressed
    @IBAction func acceptPressed(sender: AnyObject) {
        
        if ((self.passwordText.text?.isEmpty) == true) {
            let query2 = PFUser.query()
            SwiftLoading().showLoading()
            query2!.getObjectInBackgroundWithId(userid) {
                (user: PFObject?, error: NSError?) -> Void in
                if error == nil && user != nil {
                    user!["name"] = self.nameText.text;
                    user!["email"] = self.mailText.text;
                    user?.saveInBackground();
                } else {
                    print(error)
                    SwiftLoading().hideLoading()
                }
                
            }
        } else {
            let query2 = PFUser.query()
            SwiftLoading().showLoading()
            query2!.getObjectInBackgroundWithId(userid) {
                (user: PFObject?, error: NSError?) -> Void in
                if error == nil && user != nil {
                    user!["name"] = self.nameText.text;
                    user!["email"] = self.mailText.text;
                    user!["password"] = self.passwordText.text;
                    user?.saveInBackground();
                } else {
                    print(error)
                    SwiftLoading().hideLoading()
                }
            }
        }
      
        performSegueWithIdentifier("accept", sender: self.acceptButton)
        
        
    }
    
    //Cancel pressed
    @IBAction func cancelPressed(sender: AnyObject) {
        performSegueWithIdentifier("accept", sender: self.cancelButton)
    }
    
    //Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC : ProfileViewController = segue.destinationViewController as! ProfileViewController
        destinationVC.iduser = self.userid;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Text delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameText {
            mailText.becomeFirstResponder()
        }
        if textField == mailText {
            passwordText.becomeFirstResponder()
        }
        if textField == passwordText {
            mailText.resignFirstResponder()
        }
        return true
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
