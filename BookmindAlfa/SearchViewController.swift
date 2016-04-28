//
//  SearchViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 27/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController {
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var iduser = String()
    var search = String()
    var results : [PFObject] = []
    var titles : [String] = []
    var authors : [String] = []
    var covers : [PFFile] = []
    var row : Int = 0
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Search uiTextfield style
        //Padding for search text
        let padding = UIView(frame: CGRectMake(0, 0, 25, searchText.frame.height))
        searchText.leftView = padding
        searchText.leftViewMode = UITextFieldViewMode.Always
        
        //Search style
        searchText.layer.cornerRadius = searchText.frame.height/2
        searchText.attributedPlaceholder = NSAttributedString(string: "Search books or authors", attributes:[NSFontAttributeName: UIFont(name: "Montserrat", size:14)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        searchText.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        
        //back  button
        let menuimg = UIImage(named: "Cancel.png")
        backButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        backButton.setImage(menuimg, forState: UIControlState.Normal)
        
        //Search button
        let searchimg = UIImage(named: "Search.png")
        searchButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        searchButton.setImage(searchimg, forState: UIControlState.Normal)
        
        print(search)
        
        //Loading the custom cells
        let nib = UINib(nibName: "BookSearchViewCell", bundle: nil)
        resultTable.registerNib(nib, forCellReuseIdentifier: "cell")
        
        SwiftLoading().showLoading()
        //Load query
        let query = PFQuery(className: "book")
        query.whereKey("title", containsString: search)
        query.selectKeys(["title", "cover", "author"])
        
        do {
            //print(PFUser.currentUser())
            try results = query.findObjects()
            for object in results {
                titles.append(object["title"] as! String)
                covers.append(object["cover"] as! PFFile)
                authors.append(object["author"] as! String)
                print(object["title"])
            }
            print("success with objects")
        } catch {
            print("Error")
            results = []
        }
        
        SwiftLoading().hideLoading()

        print(titles)
        
        if titles.count == 0 {
            let alert = UIAlertView()
            alert.title = "Oops!"
            alert.message = "There were no results for your quest. Try another one."
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cancel" {
            let destinationVC : ProfileViewController = segue.destinationViewController as! ProfileViewController
            if let useridsegue: String = self.iduser {
                destinationVC.iduser = useridsegue
            }
        }
        if segue.identifier == "research"{
            let destinationVC : SearchViewController = segue.destinationViewController as! SearchViewController
            if let searcht: String = self.searchText.text! {
                destinationVC.search = searcht
            }
            if let useridsegue: String = self.iduser {
                destinationVC.iduser = useridsegue
            }
        }
        if segue.identifier == "bookdetail"{
            let destinationVC : BookDetailViewController = segue.destinationViewController as! BookDetailViewController
            if let titlebook: String = titles[row] {
                destinationVC.booktitle = titlebook
            }
            if let useridsegue: String = self.iduser {
                destinationVC.iduser = useridsegue
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BookSearchViewCell
        cell.authorLabel.text = authors[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row]
        
        let userImageFile = covers[indexPath.row] as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.bgCover.image = UIImage(data:imageData)
                    cell.mainCover.image = UIImage(data:imageData)
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
    
    //Determine segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "research" {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("pressed")
        print(indexPath.row)
        self.row = indexPath.row
        performSegueWithIdentifier("bookdetail", sender: self.resultTable)
        
    }


}