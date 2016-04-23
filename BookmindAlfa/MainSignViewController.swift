//
//  MainSignViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 19/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class MainSignViewController: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var userid = String()
    
    var keyboardFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Padding for MailText
        let padding = UIView(frame: CGRectMake(0, 0, 25, mailText.frame.height))
        mailText.leftView = padding
        mailText.leftViewMode = UITextFieldViewMode.Always
        
        //Padding for PasswordText
        let padding2 = UIView(frame: CGRectMake(0, 0, 25, mailText.frame.height))
        passwordText.leftView = padding2
        passwordText.leftViewMode = UITextFieldViewMode.Always
        
        //MailText style
        mailText.layer.cornerRadius = mailText.frame.height/2
        mailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        mailText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //PasswordText style
        passwordText.layer.cornerRadius = mailText.frame.height/2
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //Button style
        loginButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        loginButton.layer.borderWidth = 0
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.layer.backgroundColor = hexStringToUIColor("#00a4a8").CGColor
        
        //Helper buttons style
        createButton.titleLabel?.font = UIFont(name: "Montserrat", size: 14)
        forgotButton.titleLabel?.font = UIFont(name: "Montserrat", size: 14)
        
        //Get frame up when keyboard comes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSignViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSignViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //Hide status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == mailText {
            passwordText.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func suClick(sender: AnyObject) {
        presentController("SignUp")
    }
    
    //Present view function
    func presentController(storyboardId: String) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardId)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    @IBAction func logIn(sender: AnyObject) {
        SwiftLoading().showLoading()

        PFUser.logInWithUsernameInBackground(mailText.text!, password: passwordText.text!, block: { (user: PFUser?, error: NSError?) -> Void in
            
            if error == nil {
                self.userid = (user?.objectId)!
                print("user logged in successfully")
                SwiftLoading().hideLoading()
                self.performSegueWithIdentifier("profile", sender: self.loginButton)
                
            } else {
                SwiftLoading().hideLoading()
                let alert = UIAlertView()
                alert.title = "Wrong credentials"
                alert.message = "Your combination of password/email is not correct"
                alert.addButtonWithTitle("Retry")
                alert.show()
            }
        })
    }
    
    //Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC : ProfileViewController = segue.destinationViewController as! ProfileViewController
        if let useridsegue: String = self.userid {
            destinationVC.iduser = useridsegue
        }

    }
    
    //Determine segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if ((passwordText.text?.isEmpty) != false) {
            let alert = UIAlertView()
            alert.title = "Missing Password"
            alert.message = "Please enter a password"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            return false
        } else if ((mailText.text?.isEmpty) != false){
            let alert = UIAlertView()
            alert.title = "Missing Email"
            alert.message = "Please enter a valid Email"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            return false
        }

        
        return true
        
    }

    
    //Hex color string
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
