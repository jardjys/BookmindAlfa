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
    var row = 0
    
    @IBOutlet weak var newListButton: UIButton!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var listTable: UITableView!
    
    var lists : [PFObject] = []
    var titles : [String] = []
    var images : [PFFile] = []
    var idslist : [String] = []

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
        
        //Downloading lists:
        //Loading the custom cells
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTable.registerNib(nib, forCellReuseIdentifier: "cell")
        
        SwiftLoading().showLoading()
        print("prueba")
        print(iduser)
        

        //Load query
        let query2 = PFQuery(className: "list")
        query2.whereKey("idowner", equalTo: iduser)
        query2.selectKeys(["title", "picture", "objectId"])
       
        do {
            //print(PFUser.currentUser())
            try lists = query2.findObjects()
            for object in lists {
                titles.append(object["title"] as! String)
                images.append(object["picture"] as! PFFile)
                idslist.append(object["objectId"] as! String)
            }
            print("success with objects")
        } catch {
            print("Error")
            lists = []
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
        
        //Search uiTextfield style
        //Padding for search text
        let padding = UIView(frame: CGRectMake(0, 0, 25, searchText.frame.height))
        searchText.leftView = padding
        searchText.leftViewMode = UITextFieldViewMode.Always
        
        //Search style
        searchText.layer.cornerRadius = searchText.frame.height/2
        searchText.attributedPlaceholder = NSAttributedString(string: "Search books or authors", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        searchText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        

        
        //Button style
        newListButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        newListButton.layer.borderWidth = 0
        newListButton.layer.cornerRadius = newListButton.frame.height/2
        newListButton.layer.backgroundColor = hexStringToUIColor("#00a4a8").CGColor
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuPressed(sender: AnyObject) {
        print("menupressed")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "settings" {
            let destinationVC : SettingsViewController = segue.destinationViewController as! SettingsViewController
            if let useridsegue: String = self.iduser {
                destinationVC.userid = useridsegue
            }
        }
        if segue.identifier == "listdetail" {
            let destinationVC : ListDetailViewController = segue.destinationViewController as! ListDetailViewController
            if let useridsegue: String = self.iduser {
                destinationVC.iduser = useridsegue
            }
            if let idlist: String = self.idslist[row] {
                destinationVC.idlist = idlist
            }
        }
        else {
            //Go search
            let destinationVC : SearchViewController = segue.destinationViewController as! SearchViewController
            if let useridsegue: String = self.iduser {
                destinationVC.iduser = useridsegue
            }
            if let searchtxt: String = self.searchText.text {
                destinationVC.search = searchtxt
            }
            
        }

    }
    
    //Determine segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "search" {
            if ((searchText.text?.isEmpty) != false) {
                let alert = UIAlertView()
                alert.title = "Oops!"
                alert.message = "Please write something to search for"
                alert.addButtonWithTitle("OK")
                alert.show()
            
                return false
            }
            return true
        } else {
        return true
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
        cell.listNameLabel.text = titles[indexPath.row]
        
        let userImageFile = images[indexPath.row] as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.imageBg.image = UIImage(data:imageData)
                }
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("pressed")
        print(indexPath.row)
        self.row = indexPath.row
        print(titles[self.row])
        performSegueWithIdentifier("listdetail", sender: self.listTable)
        

        
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
    
    
}