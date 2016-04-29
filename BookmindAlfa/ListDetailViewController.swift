//
//  ListDetailViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 28/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit
import Parse

class ListDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var iduser = String();
    var idlist = String();
    var idbooks = []
    
    
    @IBOutlet weak var tableBooks: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Query to retrieve label name
        
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
