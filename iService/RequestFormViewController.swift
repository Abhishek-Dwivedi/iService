//
//  RequestFormViewController.swift
//  iService
//
//  Created by Abhishek Dwivedi on 23/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import Parse

class RequestFormViewController: UIViewController,UITextFieldDelegate {

    var contact: String?
    var email: String?
    var name: String?
    var plan: String?
    
    @IBOutlet var contactTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var chosePlanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Request Form"
        contactTxtField.text = PFUser.currentUser()?.username
        
        contactTxtField.delegate = self
        emailTxtField.delegate = self
        nameTxtField.delegate = self
    }

    //Action when user taps on Choose plan
    @IBAction func chosePlanTapped(sender: AnyObject) {
        showActionSheet(sender)
    }
    
    //Dismiss once request is submitted
    @IBAction func submitTapped(sender: AnyObject) {
        self.name = nameTxtField.text
        self.contact = contactTxtField.text
        self.email = emailTxtField.text
        self.plan = chosePlanButton.titleLabel?.text
        
        print(self.name,self.contact,self.email,self.plan)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Shows an action sheet with Plans
    func showActionSheet(sender: AnyObject) {
        
        let optionsMenu = UIAlertController(title: "Service Plans", message: "Choose a Plan", preferredStyle:.ActionSheet)
        
        let action1 = UIAlertAction(title: "Gold", style: .Default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            print("Gold plan selected")
            self.chosePlanButton.setTitle("Gold Plan", forState: .Normal)
        })
        
        let action2 = UIAlertAction(title: "Silver", style: .Default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            print("Silver plan selected")
            self.chosePlanButton.setTitle("Silver Plan", forState: .Normal)
        })
        
        let action3 = UIAlertAction(title: "Bronze", style: .Default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            print("Bronze plan selected")
            self.chosePlanButton.setTitle("Bronze Plan", forState: .Normal)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
        })
        
        optionsMenu.addAction(action1)
        optionsMenu.addAction(action2)
        optionsMenu.addAction(action3)
        optionsMenu.addAction(cancelAction)
        
        self.presentViewController(optionsMenu, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}