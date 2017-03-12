//
//  StudentLoginViewController.swift
//  Student_Professor
//
//  Created by Malgireddy,Prashanth Reddy on 4/3/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class StudentLoginViewController: UIViewController,UITextFieldDelegate {

    var titleChanged: String = ""
    var section:[String] = []
    var sections:[Sections] = []
    var student:Students!
    var status = false
    override func viewDidLoad() {
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "facReg.jpg")!)
        super.viewDidLoad()
        //   self.navigationItem.title = titleChanged
        // Do any additional setup after loading the view.
        loginUsername.delegate = self
        loginPassword.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image13.jpg")!)
    }
    
    let store = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
        KCSStoreKeyCollectionName : "Sections",
        KCSStoreKeyCollectionTemplateClass : Sections.self
        ])
    
    
    let store2 = KCSAppdataStore.storeWithOptions([ // a store represents a local connection to the cloud data base
        KCSStoreKeyCollectionName : "Students",
        KCSStoreKeyCollectionTemplateClass : Students.self
        ])

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var loginUsername: UITextField!
    
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBAction func studentLogin(sender: AnyObject) {
        let id = loginUsername.text
        let pwd = loginPassword.text
        
        if (id == "") || (pwd == "")
        {
            self.displayAlertControllerWithTitle("Wait!", message: "Something is missing")
        }
        else
        {
        self.shouldPerformSegueWithIdentifier("studentLoginSegue", sender: "")
    }
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier:String, sender: AnyObject?)->Bool{
        if identifier == "studentLoginSegue"
        {
            KCSUser.loginWithUsername(
                loginUsername.text!,
                password: loginPassword.text!,
                withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                    if errorOrNil == nil {
                        //the log-in was successful and the user is now the active user and credentials saved
                        //  self.displayAlertControllerWithTitle("Login successful", message: "Welcome!")
                        //hide log-in view and show main app content
                        
                        let query:KCSQuery = KCSQuery(onField: "Student_ID", withExactMatchForValue: self.loginUsername.text!)
                        self.store2.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                            
                            self.student = objectsOrNil[0] as! Students
                            }, withProgressBlock: nil)
                        LoggedUser.loggeduser2 = self.loginUsername.text!
                        
                        
                        self.status = true

                        self.store.queryWithQuery(KCSQuery(),withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                                
                                if errorOrNil == nil
                                {
                                    if let objects = objectsOrNil as [AnyObject]!
                                        
                                        
                                    {
                                        for object in objects
                                            
                                        {
                                            
                                            let x = object as! Sections
                                            self.fetch(x)
                                            
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    print("Error")
                                }
                            },
                            withProgressBlock: nil
                        )
                                            }
                    else {
                        //there was an error with the update save
                        //     let message = errorOrNil.localizedDescription
                        self.displayAlertControllerWithTitle("Login failed", message: "Sorry! Wrong Username or Password")
                        self.status = false
                    }
            })
            
        }
        return status
    }
    
    
    func fetch(object: Sections)
    {
      
        sections.append(object)
        for item in sections
        {
            section.append(item.crn!)
        }
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.visibleViewController?.navigationItem.title = titleChanged
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studentLoginSegue"
        {
            let tabbar:UITabBarController = segue.destinationViewController as! UITabBarController
            let vc = tabbar.viewControllers![0] as! StudentAttendanceViewController
            vc.classesAvailable = self.section
            vc.student = self.student
        }
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
