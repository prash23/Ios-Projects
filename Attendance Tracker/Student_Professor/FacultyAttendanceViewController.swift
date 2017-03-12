//
//  FacultyAttendanceViewController.swift
//  Student_Professor
//
//  Created by Malgireddy,Prashanth Reddy on 4/3/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class FacultyAttendanceViewController: UIViewController,UITextFieldDelegate {
    var array:[String] = []
    var faculty:Faculty!
    var fac:Faculty!
    var classesAvailable:[String] = []
    var crns:[String] = []
    var selectedSec:String = ""
    var profDictionary:[String:String] = [:]
    override func viewDidLoad() {
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "facRegister1.png")!)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        self.tabBarController?.navigationItem.hidesBackButton = true
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutButton
        let query = KCSQuery()
        store3.queryWithQuery(query, withCompletionBlock: {(objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            for object in objectsOrNil
            {
                let fac = object as! facAttendance
                if !(self.array.contains(self.selectedSec))
                {
                    self.array.append(fac.facCrn!)
                }
            }
            
            }, withProgressBlock: nil)
        attendancePin.delegate = self
        enterCrn.delegate = self
    }

    let store = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Sections",
        KCSStoreKeyCollectionTemplateClass : Sections.self
        ])

    let store2 = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Faculty",
        KCSStoreKeyCollectionTemplateClass : Faculty.self
        ])
    
    let store3 = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "facAttendance",
        KCSStoreKeyCollectionTemplateClass : facAttendance.self
        ])
    
    
    @IBOutlet weak var attendancePin: UITextField!
    
    @IBOutlet weak var enterCrn: UITextField!
    @IBOutlet weak var sections: UISegmentedControl!
    
    @IBAction func classSelector(sender: UISegmentedControl)
    {
        let selectedSegment = sections.selectedSegmentIndex
        let selectedSection = sections.titleForSegmentAtIndex(selectedSegment)!
        selectedSec = selectedSection
    }
   
    @IBAction func addSection(sender: AnyObject) {
        let value:String! = enterCrn.text!
        let section = Sections()
        let faculty2 = Faculty()
        if value == ""
        {
            let alert = UIAlertView()
            alert.title = "Error!"
            alert.message = "Please select any class"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else if faculty.Section?.contains(value) == true || crns.contains(value) == true
        {
            let alert = UIAlertView()
            alert.title = "Sorry!"
            alert.message = "You have already addded this section"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else if classesAvailable.contains(value) == true && faculty.Section?.contains(value) == false
        {
            let alert = UIAlertView()
            alert.title = "Sorry!"
            alert.message = "This section is allotted to someone else"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else
        {
            crns.append(value!)
            if crns.count <= faculty.Section!.count
            {
                faculty.Section?.append(value)
                crns = []
                for item in faculty.Section!
                {
                    crns.append(item)
                }
            }
            
            sections.hidden = false
            sections.insertSegmentWithTitle(value, atIndex: sections.numberOfSegments, animated: false)
            
            for item in crns
            {
                section.crn = item
            }
            
            store.saveObject(
                section,
                withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                    if errorOrNil != nil  {
                        //save failed
                     //   let message = errorOrNil.localizedDescription
                        self.displayAlertControllerWithTitle("Error!", message: "Saving your Crn failed")
                    }
                    else
                        {
                            //save was successful
                            self.displayAlertControllerWithTitle("Success", message: "Saving your Crn Successful")
                            print(LoggedUser.loggeduser)
                            let query:KCSQuery = KCSQuery(onField: "Faculty_ID", withExactMatchForValue: LoggedUser.loggeduser)
                            self.store2.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                                for a in objectsOrNil
                                {
                                    self.fac = a as! Faculty
                                }
                                
                                self.store2.removeObject(
                                    objectsOrNil,
                                    withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                                        if errorOrNil != nil {
                                            //error occurred - add back into the list
                                            
                                            NSLog("Delete failed, with error: %@", errorOrNil.localizedFailureReason!)
                                        } else {
                                            //delete successful - UI already updated
                                            NSLog("deleted response: %@", deletionDictOrNil)
                                            print("deleted successfull")
                                            
                                            faculty2.Faculty_ID = self.faculty.Faculty_ID
                                            faculty2.FirstName = self.faculty.FirstName
                                            faculty2.LastName = self.faculty.LastName
                                            faculty2.Password = self.faculty.Password
                                            faculty2.Section = self.crns
                                            
                                            self.store2.saveObject(
                                                faculty2,
                                                withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                                                    if errorOrNil != nil  {
                                                        //save failed
                                                        //   let message = errorOrNil.localizedDescription
                                                        self.displayAlertControllerWithTitle("Error!", message: "Saving your Crn failed")
                                                    }
                                                    else
                                                    {
                                                        //save was successful
                                                        self.displayAlertControllerWithTitle("Success", message: "Saving your Crn Successful")
                                                        
                                                    }
                                                    self.displayAlertControllerWithTitle("Invalid crn", message: "Try again")
                                                },
                                                withProgressBlock: nil
                                                
                                            )
                                            
                                        }
                                    },
                                    withProgressBlock: nil
                                )
                                
                                }, withProgressBlock: nil)
                    }
                   
                },
                withProgressBlock: nil
                
            )
            
            
           
            
        }
    }
    
    
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    
    @IBAction func submitPin(sender: AnyObject) {
        let facattendance = facAttendance()
       
        
        let query = KCSQuery()
        store3.queryWithQuery(query, withCompletionBlock: {(objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            for object in objectsOrNil
            {
                let fac = object as! facAttendance
                if !(self.array.contains(self.selectedSec))
                {
                    self.array.append(fac.facCrn!)
                }
                print(fac.facCrn)
                print(self.array)
            }
            
            }, withProgressBlock: nil)
        
        
        if (array.contains(selectedSec))
            {
                let query:KCSQuery = KCSQuery(onField: "facCrn", withExactMatchForValue: selectedSec)
                self.store3.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                    
                    self.store3.removeObject(
                        objectsOrNil,
                        withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                            if errorOrNil != nil {
                                //error occurred - add back into the list
                                
                                NSLog("Delete failed, with error: %@", errorOrNil.localizedFailureReason!)
                            }
                            else {
                                //delete successful - UI already updated
                                NSLog("deleted response: %@", deletionDictOrNil)
                                print("deleted successfull")
                                facattendance.faculty_ID = LoggedUser.loggeduser
                                facattendance.facCrn = self.selectedSec
                                facattendance.password = self.attendancePin.text!
                                self.profDictionary[self.selectedSec] = self.attendancePin.text!
                                
                                self.store3.saveObject(
                                    facattendance,
                                    withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                                        if errorOrNil != nil  {
                                            //save failed
                                            //   let message = errorOrNil.localizedDescription
                                            self.displayAlertControllerWithTitle("Error!", message: "try again")
                                        }
                                        else
                                        {
                                            //save was successful
                                            self.displayAlertControllerWithTitle("Success", message: "you have done it")
                                            
                                        }
//                                        self.displayAlertControllerWithTitle("Invalid crn", message: "Try again")
                                    },
                                    withProgressBlock: nil
                                )
                            }
                        },
                        withProgressBlock: nil
                    )
                    
                    }, withProgressBlock: nil)
            }

        else
        {
            facattendance.faculty_ID = LoggedUser.loggeduser
            facattendance.facCrn = selectedSec
            facattendance.password = attendancePin.text!
            profDictionary[selectedSec] = attendancePin.text!
            
            store3.saveObject(
                facattendance,
                withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                    if errorOrNil != nil  {
                        //save failed
                        //   let message = errorOrNil.localizedDescription
                        self.displayAlertControllerWithTitle("Error!", message: "try again")
                    }
                    else
                    {
                        //save was successful
                        self.displayAlertControllerWithTitle("Success", message: "you have done it")
                        
                    }
                    
                   
                },
                withProgressBlock: nil
            )
            

        }
        

    }
    
    func logout()
    {
       //self.dismissViewControllerAnimated(true, completion: nil)
        faculty = nil
        LoggedUser.loggeduser = ""
        crns = []
        sections.removeAllSegments()
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.visibleViewController?.navigationItem.title = "Attendance"
        sections.removeAllSegments()

        if faculty.Section!.count == 0
        {
            sections.hidden = true
        }
        else
        {
            sections.removeAllSegments()
            for segment in faculty.Section! {
                sections.insertSegmentWithTitle(segment, atIndex: sections.numberOfSegments, animated: false)
            }
        }

        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue1")
        {
            let vc = segue.destinationViewController as! AttendanceViewController
            vc.currentLoggedUser = LoggedUser.loggeduser
           print(profDictionary)
            vc.selectedCrn = selectedSec
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
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
