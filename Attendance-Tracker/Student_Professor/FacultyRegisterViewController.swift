//
//  RegisterViewController.swift
//  Student_Professor
//
//  Created by Prashanth Reddy Malgireddy on 3/19/16.
//  Copyright © 2016 Prashanth Reddy Malgireddy. All rights reserved.
//

import UIKit

class FacultyRegisterViewController: UIViewController,UITextFieldDelegate {

    var changeTitle = ""
    
    var crns:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "facReg.jpg")!)
        // Do any additional setup after loading the view.
        registerID.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        createPwd.delegate = self
        confirmPwd.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image12.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var registerID: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var createPwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    
   
    let store = KCSAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Faculty",
        KCSStoreKeyCollectionTemplateClass : Faculty.self
        ])
    
    @IBAction func facRegister(sender: AnyObject) {
        
        let id = registerID.text
        let fName = firstName.text
        let lName = lastName.text
        let cPwd = createPwd.text
        let conPwd = confirmPwd.text
        
        if (id == "") || (fName == "") || (lName == "") || (cPwd == "") || (conPwd == "")
        {
            self.displayAlertControllerWithTitle("Sorry!", message: "All fields are mandatory")
        }
        else
        {
        
        
        KCSUser.userWithUsername(
            registerID.text!,               // making up bogus data -- what you *should* use is usernameTF.text! and passwordTF.text!
            password: createPwd.text!,
            fieldsAndValues: [
                KCSUserAttributeGivenname : firstName.text!,
                KCSUserAttributeSurname : lastName.text!
        
            ],withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil != nil {
                    
                    let message = errorOrNil.localizedDescription
                    self.displayAlertControllerWithTitle("Create account failed", message: message)
                }
                else if(self.createPwd.text! == self.confirmPwd.text!){
                    self.displayAlertControllerWithTitle("Account Creation Successful", message: "User created. Welcome!")
                    let faculty = Faculty()
                    faculty.Faculty_ID = self.registerID.text
                    faculty.FirstName = self.firstName.text
                    faculty.LastName = self.lastName.text
                    faculty.Password = self.createPwd.text
                    faculty.Section = self.crns
                    
                    
                    self.store.saveObject(
                        faculty,
                        withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                            if errorOrNil != nil  {
                                //save failed
                                let message = errorOrNil.localizedDescription
                                self.displayAlertControllerWithTitle("Create account failed", message: message)
                            }
                            else
                                if(self.createPwd.text! == self.confirmPwd.text!){
                                    //save was successful
                                    self.displayAlertControllerWithTitle("Account Creation Successful", message: "User created. Welcome!")
                                    
                            }
                            self.displayAlertControllerWithTitle("Invalid Username/Password", message: "Try again")
                        },
                        withProgressBlock: nil
                        
                    )
                }
                else
                {
                   self.displayAlertControllerWithTitle("Passwords does not match", message: "Try Again")
                }
                
            }
        )
    }
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.visibleViewController?.navigationItem.title = changeTitle
        if changeTitle == "Student Registration" {
            registerID.placeholder = "Student ID"
        }
        else
        {
            registerID.placeholder = "Faculty ID"
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
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
