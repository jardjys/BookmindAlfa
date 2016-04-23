//
//  SecondSignUpViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 21/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class SecondSignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var dobText: UITextField!
    @IBOutlet weak var sexText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let genderArray : [String]  = ["Male", "Female"]
    var countryArray : [String] = []
    var keyboardFlag = false
    
   
    var name = String()
    var email = String()
    var password = String()
    
    
    @IBOutlet weak var uploadButton: UIButton!
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
        
        //Image circle
        self.imageProfile.layer.cornerRadius = imageProfile.frame.height/1.75
        self.imageProfile.clipsToBounds = true
        
        //Upload Button style
        uploadButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.cornerRadius = uploadButton.frame.height/2
        uploadButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //DOB style
        dobText.layer.cornerRadius = dobText.frame.height/2
        dobText.attributedPlaceholder = NSAttributedString(string: "Date of birth", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        dobText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)

        //Padding for DOB
        let padding = UIView(frame: CGRectMake(0, 0, 25, dobText.frame.height))
        dobText.leftView = padding
        dobText.leftViewMode = UITextFieldViewMode.Always
        
        //Gender style
        sexText.layer.cornerRadius = dobText.frame.height/2
        sexText.attributedPlaceholder = NSAttributedString(string: "Gender", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        sexText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //Padding for Gender
        let padding2 = UIView(frame: CGRectMake(0, 0, 25, sexText.frame.height))
        sexText.leftView = padding2
        sexText.leftViewMode = UITextFieldViewMode.Always
        
        //Contry style
        countryText.layer.cornerRadius = dobText.frame.height/2
        countryText.attributedPlaceholder = NSAttributedString(string: "Select country", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        countryText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        //Padding for country
        let padding3 = UIView(frame: CGRectMake(0, 0, 25, countryText.frame.height))
        countryText.leftView = padding3
        countryText.leftViewMode = UITextFieldViewMode.Always
        
        //Retrieve countries into picker
        for code in NSLocale.ISOCountryCodes() as [String] {
            let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayNameForKey(NSLocaleIdentifier, value: id) ?? "Country not found for code: \(code)"
                countryArray.append(name)
        }

        //Picker for sex
        let picker = UIPickerView()
        picker.tag = 1
        picker.delegate = self
        sexText.inputView = picker
        
        //Sex done toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SecondSignUpViewController.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        sexText.inputAccessoryView = toolBar
        
        //Picker for country
        let countrypicker = UIPickerView()
        countrypicker.delegate = self
        countryText.inputView = countrypicker
        
        //Country done toolbar
        let toolBarC = UIToolbar()
        toolBarC.barStyle = UIBarStyle.Default
        toolBarC.translucent = true
        toolBarC.sizeToFit()
        let doneButtonC = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SecondSignUpViewController.donePicker))
        
        toolBarC.setItems([doneButtonC], animated: false)
        toolBarC.userInteractionEnabled = true
        countryText.inputAccessoryView = toolBarC
        
        //Button style
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Cancel button style
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //Get frame up when keyboard comes this goes in viewdidload
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSignViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainSignViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)

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

    
    //Pick birthday
    @IBAction func dobPick(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date

        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SecondSignUpViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

        //Toolbar datepicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SecondSignUpViewController.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        dobText.inputView = datePickerView
        dobText.inputAccessoryView = toolBar
        
    }
    
    //function for doneclick in dob
    
    func donePicker(){
        dobText.resignFirstResponder()
        sexText.resignFirstResponder()
        countryText.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dobText.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    //Hide Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //Picker functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1 {
            return genderArray.count
        } else {
            return countryArray.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 1 {
            return genderArray[row]
        }
        else{
            return countryArray[row]
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1 {
            sexText.text = genderArray[row]
        } else {
            countryText.text = countryArray[row]
        }
        
    }
    
    //Cancel button Action
    
    @IBAction func cancelButton(sender: AnyObject) {
        presentController("mainSign")
    }
    
    
    //Image selector
    @IBAction func selectImage(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Use camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
        })
        
        let picturesAction = UIAlertAction(title: "Use your photos", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(picturesAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    //Sign up button
    @IBAction func signUp(sender: AnyObject) {
        
        if ((dobText.text?.isEmpty) != false) {
            let alert = UIAlertView()
            alert.title = "Missing birthday"
            alert.message = "Please enter a birthday"
            alert.addButtonWithTitle("OK")
            alert.show()
        } else if ((sexText.text?.isEmpty) != false){
            let alert = UIAlertView()
            alert.title = "Missing gender"
            alert.message = "Please enter a valid gender"
            alert.addButtonWithTitle("OK")
            alert.show()
        } else if ((countryText.text?.isEmpty) != false){
            let alert = UIAlertView()
            alert.title = "Missing country"
            alert.message = "Please select a country"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        let user = PFUser()
        user.email = email
        user.password = password
        [user .setObject(name, forKey: "name")]
        [user .setObject(dobText.text!, forKey: "dob")]
        [user .setObject(sexText.text!, forKey: "sex")]
        [user .setObject(countryText.text!, forKey: "country")]
        
        
        
        let imageData = UIImageJPEGRepresentation(self.imageProfile.image!, 1.0)
        let imageFile = PFFile(name: "PP", data: imageData!)
        user["profilepicture"] = imageFile
        user["username"] = email

        SwiftLoading().showLoading()
        user.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in

            if success {
                SwiftLoading().hideLoading()
                print("User signed up successfully")
                self.presentController("mainSign")
            } else {
                print(error)
                SwiftLoading().hideLoading()
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "There was an error processing your request"
                alert.addButtonWithTitle("Try again.")
                alert.show()
            }
        })

        
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
    
    //Present controller
    func presentController(storyboardId: String) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardId)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
}; extension SecondSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickMediaFromSource(source: UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imageProfile.image = image
    }
    
}


