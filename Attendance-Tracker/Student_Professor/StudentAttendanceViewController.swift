//
//  StudentAttendanceViewController.swift
//  Student_Professor
//
//  Created by Malgireddy,Prashanth Reddy on 4/3/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class StudentAttendanceViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    var array:[String] = []
    var classesAvailable:[String] = []
    var registeredClasses:[String] = []
    var student:Students!
    var selectedSec = ""
    var stuDictionary:[String:String] = [:]
    override func viewDidLoad() {
      // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image25.gif")!)
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
       
       selectClasses.delegate = self
       attendancePin.delegate = self
 
        let pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
         pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        selectClasses.inputView = pickerView
        selectClasses.inputAccessoryView = toolBar
        
        let logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutButton
        
        let query = KCSQuery()
        store3.queryWithQuery(query, withCompletionBlock: {(objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
        //    print(objectsOrNil)
            for object in objectsOrNil
            {
                let student = object as! stuAttendance
                if !(self.array.contains(student.student_ID!))
                {
                    self.array.append(student.student_ID!)
                }
           //     print(self.array)
            }
            
            }, withProgressBlock: nil)
       
        
    }
    let store = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Students",
        KCSStoreKeyCollectionTemplateClass : Students.self
        ])
    let store3 = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "stuAttandance",
        KCSStoreKeyCollectionTemplateClass : stuAttendance.self
        ])
    
    

    @IBOutlet var selectClasses: UITextField!
    
    @IBAction func submit(sender: AnyObject)
    {
         let stuattendance:stuAttendance = stuAttendance()
        
        
        
        if (array.contains(LoggedUser.loggeduser2))
        {
            let query:KCSQuery = KCSQuery(onField: "student_ID", withExactMatchForValue: LoggedUser.loggeduser2)
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
                            stuattendance.student_ID = LoggedUser.loggeduser2
                            stuattendance.section = self.selectedSec
                            stuattendance.password = self.attendancePin.text!
                           
                            
                            self.store3.saveObject(
                                stuattendance,
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
                    },
                    withProgressBlock: nil
                )
                
                }, withProgressBlock: nil)
        }
       else
        {
       
        stuattendance.student_ID = LoggedUser.loggeduser2
        stuattendance.section = self.selectedSec
        stuattendance.password = self.attendancePin.text!
        
//        print(stuattendance.student_ID!)
//        print(stuattendance.section!)
//        print(stuattendance.password!)
        store3.saveObject(
            stuattendance,
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
                self.displayAlertControllerWithTitle("Invalid crn", message: "Try again")
            },
            withProgressBlock: nil
            
        )

        
    }
    }
    @IBOutlet weak var classesRegistered: UISegmentedControl!
    
    @IBOutlet weak var attendancePin: UITextField!
    
    @IBAction func addClass(sender: AnyObject) {
        let value:String? = selectClasses.text!
        let student2 = Students()
        if value == ""
        {
           // classesRegistered.hidden = true
            let alert = UIAlertView()
            alert.title = "Sorry!"
            alert.message = "Please select a valid class"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
       else if classesAvailable.contains(value!) == false
        {
            let alert = UIAlertView()
            alert.title = "Sorry!"
            alert.message = "Please select a valid class"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else if registeredClasses.contains(value!) == true
        {
            let alert = UIAlertView()
            alert.title = "Sorry!"
            alert.message = "You have already addded this section"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        else
        {
            registeredClasses.append(value!)
            if registeredClasses.count <= student.sections!.count
            {
                student.sections!.append(value!)
                registeredClasses = []
                for item in student.sections!
                {
                    registeredClasses.append(item)
                }
            }
            
            
            classesRegistered.hidden = false
            classesRegistered.insertSegmentWithTitle(value, atIndex: classesRegistered.numberOfSegments, animated: false)
            
       
       
        let query:KCSQuery = KCSQuery(onField: "Student_ID", withExactMatchForValue: LoggedUser.loggeduser2)
        self.store.queryWithQuery(query, withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            print(objectsOrNil.count)

            self.store.removeObject(
                objectsOrNil,
                withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                    if errorOrNil != nil {
                        //error occurred - add back into the list
                        
                        NSLog("Delete failed, with error: %@", errorOrNil.localizedFailureReason!)
                    } else {
                        //delete successful - UI already updated
                        NSLog("deleted response: %@", deletionDictOrNil)
                        print("deleted successfull")
                        student2.Student_ID = self.student.Student_ID
                        student2.FirstName = self.student.FirstName
                        student2.LastName = self.student.LastName
                        student2.Password = self.student.Password
                        student2.sections = self.registeredClasses
                        
                        
                        self.store.saveObject(
                            student2,
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
        
        
        
        
        
            classesAvailable.removeAtIndex(classesAvailable.indexOf(value!)!)
        
        //print(student.Student_ID)
    
 }

    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }


    @IBAction func classSelector(sender: UISegmentedControl)
    {
        let selectedSegment = classesRegistered.selectedSegmentIndex
        let selectedSection = classesRegistered.titleForSegmentAtIndex(selectedSegment)
        selectedSec = selectedSection!
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        print(classesAvailable.count)
        return classesAvailable.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (classesAvailable[row] )
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectClasses.text = (classesAvailable[row] )
      
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
         return true
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "stuSegue")
//        {
//            let vc = segue.destinationViewController as! AttendanceViewController
//            vc.dictionary2 = stuDictionary
//        }
//    }
    
    func donePicker()
    {
        selectClasses.resignFirstResponder()
    }
    
    func logout()
    {
        student = nil
        LoggedUser.loggeduser = ""
        registeredClasses = []
        // self.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.visibleViewController?.navigationItem.title = "Attendance"
        print(student.sections!.count)
        if student.sections!.count == 0
        {
            classesRegistered.removeAllSegments()
            classesRegistered.hidden = true
        }
        else
        {
           classesRegistered.removeAllSegments()
           
            for segment in student.sections! {
                classesRegistered.insertSegmentWithTitle(segment, atIndex: classesRegistered.numberOfSegments, animated: false)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
