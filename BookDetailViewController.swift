//
//  BookDetailViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 28/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class BookDetailViewController: UIViewController {


    @IBOutlet weak var synopsysLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgCover: UIImageView!
    @IBOutlet weak var mainCover: UIImageView!
    var booktitle = String()
    var iduser = String()
    var results : [PFObject] = []
    var titles : [String] = []
    var covers : [PFFile] = []
    var authors : [String] = []
    var synopsys : [String] = []
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var listButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(booktitle)
        print(iduser)
        SwiftLoading().showLoading()
        //Load query
        let query = PFQuery(className: "book")
        query.whereKey("title", containsString: booktitle)
        query.selectKeys(["title", "cover", "author", "synopsys"])
        
        do {
            //print(PFUser.currentUser())
            try results = query.findObjects()
            for object in results {
                titles.append(object["title"] as! String)
                covers.append(object["cover"] as! PFFile)
                authors.append(object["author"] as! String)
                synopsys.append(object["synopsys"] as! String)
            }
            print("success with objects")
        } catch {
            print("Error")
            results = []
        }
        
        titleLabel.text = titles[0]
        authorLabel.text = authors[0]
        synopsysLabel.text = synopsys[0]
        
        let userImageFile = covers[0] as PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.bgCover.image = UIImage(data:imageData)
                    self.mainCover.image = UIImage(data:imageData)
                }
            }
        }
        
        SwiftLoading().hideLoading()
        
        //Label Style
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 20)
        authorLabel.font = UIFont(name:"Montserrat", size: 14)
        synopsysLabel.font = UIFont(name:"Montserrat", size: 14)
        titleLabel.numberOfLines = 0
        synopsysLabel.numberOfLines = 0
        
        //back  button
        let menuimg = UIImage(named: "Cancel.png")
        backButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        backButton.setImage(menuimg, forState: UIControlState.Normal)
        
        //Button style
        listButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
        listButton.layer.borderWidth = 1
        listButton.layer.cornerRadius = listButton.frame.height/2
        listButton.layer.borderColor = UIColor.whiteColor().CGColor
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

    }


}
