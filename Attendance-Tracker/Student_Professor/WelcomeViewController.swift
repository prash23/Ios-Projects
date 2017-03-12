//
//  ViewController.swift
//  Student_Professor
//
//  Created by Prashanth Reddy Malgireddy on 3/19/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
//        navigationController?.navigationBar.barTintColor = UIColor.brownColor()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image20.jpg")!)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "faculty")
        {
            let tabbar:UITabBarController = segue.destinationViewController as! UITabBarController
            let vc:FacultyLoginViewController = tabbar.viewControllers![0] as! FacultyLoginViewController
            let vc1:FacultyRegisterViewController = tabbar.viewControllers![1] as! FacultyRegisterViewController
            vc.titleChanged = "Faculty Login"
            vc1.changeTitle = "Faculty Registration"
            
        }
        else if (segue.identifier == "student")
        {
            let tabbar:UITabBarController = segue.destinationViewController as! UITabBarController
            let vc:StudentLoginViewController = tabbar.viewControllers![0] as! StudentLoginViewController
            let vc1:StudentRegisterViewController = tabbar.viewControllers![1] as! StudentRegisterViewController
            vc.titleChanged = "Student Login"
            vc1.changeTitle = "Student Registration"
        }
    }

}

