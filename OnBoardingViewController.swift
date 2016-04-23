//
//  OnBoardingViewController.swift
//  BookmindAlfa
//
//  Created by Juan Andrés Rocha Díaz on 19/04/16.
//  Copyright © 2016 Juan Andrés Rocha Díaz. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIPageViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the scene as initial.
        setViewControllers([getOBE1()], direction: .Forward, animated: false, completion: nil)
        //Setting the dataSource as self.
        dataSource = self
        //Setting background color
        view.backgroundColor = UIColor(netHex:0x007471)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Get the OBE1ViewController scene.
    func getOBE1() -> OBE1ViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OBE1ViewController") as! OBE1ViewController
    }
    
    //Get the OBE2ViewController scene.
    func getOBE2() -> OBE2ViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OBE2ViewController") as! OBE2ViewController
    }
    
    //Get the OBE3ViewController scene.
    func getOBE3() -> OBE3ViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OBE3ViewController") as! OBE3ViewController
    }

    //Hiding the status bar.
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    

}
//Implementing the data source
extension OnBoardingViewController : UIPageViewControllerDataSource {
    //Get previous page
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(OBE3ViewController) {
         return getOBE2()
         } else if viewController.isKindOfClass(OBE2ViewController){
         return getOBE1()
         } else {
         return nil
         }
    }
    
    //Get next page
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        if viewController.isKindOfClass(OBE1ViewController) {
            return getOBE2()
        } else if viewController.isKindOfClass(OBE2ViewController){
            return getOBE3()
        } else {
            return nil
        }
    }
    
    //Activate page dots, 3 is the number of pages
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    //Initialize the dots in first page
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}