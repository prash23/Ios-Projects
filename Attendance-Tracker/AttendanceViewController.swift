//
//  AttendanceViewController.swift
//  Student_Professor
//
//  Created by Somu,Vinod Reddy on 4/15/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController {

    var currentLoggedUser = ""
    var facCrns:String = ""
    var facPassword:String = ""
    var dictionary:[String:String] = [:]
    var presentedStudents:[String] = []
    var selectedCrn = ""
    var arrayValue:[String] = []
  
    let store = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "facAttendance",
        KCSStoreKeyCollectionTemplateClass : facAttendance.self
        ])
    let store1 = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "stuAttandance",
        KCSStoreKeyCollectionTemplateClass : stuAttendance.self
        ])
    
    let store2 = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "class",
        KCSStoreKeyCollectionTemplateClass : PresentStudents.self
        ])
   
    override func viewDidLoad() {
        super.viewDidLoad()
       dateTF.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                // Do any additional setup after loading the view.
       
    }

    

       
    @IBOutlet weak var dateTF: UITextField!
    
    @IBAction func validateClicked(sender: AnyObject)
    {
        let query:KCSQuery = KCSQuery(onField: "facCrn", withExactMatchForValue: selectedCrn)
        //    print(LoggedUser.loggeduser)
        self.store.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
         //   print(objectsOrNil.count)
            for object in objectsOrNil
            {
                let facAtten = object as! facAttendance
                self.facCrns = facAtten.facCrn!
                self.facPassword = facAtten.password!
            }
                print(self.facCrns)
            
            }, withProgressBlock: nil)
        
        let query1:KCSQuery = KCSQuery(onField: "section", withExactMatchForValue: facCrns)
       
        self.store1.queryWithQuery(query1, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            print(objectsOrNil.count)
            for object in objectsOrNil
            {
                let stuAtten = object as! stuAttendance
                if stuAtten.password! == self.facPassword
                {
                    self.presentedStudents.append(stuAtten.student_ID!)
                }
            }
            print(self.presentedStudents)
            
            let presentStudents:PresentStudents = PresentStudents()
            presentStudents.date = self.dateTF.text
            presentStudents.faculty_ID = LoggedUser.loggeduser
            presentStudents.section_ID = self.facCrns
            presentStudents.presentStudents = self.presentedStudents
            
            self.store2.saveObject(
                presentStudents,
                withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                    if errorOrNil != nil  {
                        //save failed
                        let message = errorOrNil.localizedDescription
                        self.displayAlertControllerWithTitle("Error loading list to server", message: message)
                    }
                    else
                    {
                    self.displayAlertControllerWithTitle("Thank You", message: "Students list is successfully stored")
    
                    }
                                    },
                withProgressBlock: nil
                
            )
            
           
            self.arrayValue = self.presentedStudents
            self.presentedStudents = []
            }, withProgressBlock: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "studentsTable"
        {
            let vc = segue.destinationViewController as! PresentStudentsTableViewController
            vc.presentStudents = self.arrayValue
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
