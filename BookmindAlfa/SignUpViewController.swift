
//
//  SignUpViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 20/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var keyboardFlag = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Gradient Background
        let topColor = hexStringToUIColor("#00a4a8").CGColor
        let bottomColor = UIColor.blackColor().CGColor
        let gradientColors: [CGColor] = [topColor, bottomColor]
        let gradientLocations:[CGFloat] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
        //Label style
        instructionsLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        
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
        passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //Button style
        continueButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        continueButton.layer.borderWidth = 1
        continueButton.layer.cornerRadius = continueButton.frame.height/2
        continueButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Back button style
        backButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = backButton.frame.height/2
        backButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Get frame up when keyboard comes this goes in viewdidload
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSignViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSignViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)


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

    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    //Back button click
    @IBAction func backButtonClick(sender: AnyObject) {
        presentController("mainSign")
    }
    
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
        } else if ((nameText.text?.isEmpty) != false){
            let alert = UIAlertView()
            alert.title = "Missing Name"
            alert.message = "Please enter your beutiful name"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            return false
        }
        
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC : SecondSignUpViewController = segue.destinationViewController as! SecondSignUpViewController
        
        if let name: String = self.nameText.text {
            destinationVC.name = name
        }
        
        if let email: String = self.mailText.text {
            destinationVC.email = email
        }
        
        if let pass: String = self.passwordText.text {
            destinationVC.password = pass
        }
        
    }
    
    //Texfield return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameText {
            mailText.becomeFirstResponder()
        }
        if textField == mailText {
            passwordText.becomeFirstResponder()
        }
        return true
    }
    
    //Validate email address
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }

    
    //Hex color reader
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
    
    //Present view
    func presentController(storyboardId: String) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardId)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
}
