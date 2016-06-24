//
//  SignUpViewController.swift
//  iService
//
//  Created by Abhishek Dwivedi on 18/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var userTypeControl: UISegmentedControl!
    
    @IBOutlet var anActivityIndicator: UIActivityIndicatorView!
    var buttonTitlePressed: String?
    var isSignIn: Bool?
    var isCustomer: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        determineSignInOrRegister()
        usernameTxtField.delegate = self
        passwordTxtField.delegate = self
    }

    func determineCustomerOrAdmin(user: PFUser) {
        print(user["isCustomer"])
        let isCustomer = user["isCustomer"] as? Bool
        if isCustomer == true {
            self.isCustomer = true
        } else {
            self.isCustomer = false
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.anActivityIndicator.startAnimating()
        
        //----------Register-----------
        if isSignIn == false {
            
            //Check if all the fields has been filled by user
            if self.usernameTxtField.text == "" || self.passwordTxtField.text == "" || userTypeControl.selectedSegmentIndex == -1 {
                if usernameTxtField.text == "" {
                    usernameTxtField.layer.borderColor = UIColor.redColor().CGColor
                    usernameTxtField.layer.borderWidth = 1.0
                }
                if passwordTxtField.text == "" {
                    passwordTxtField.layer.borderColor = UIColor.redColor().CGColor
                    passwordTxtField.layer.borderWidth = 1.0
                }
                if userTypeControl.selectedSegmentIndex == -1 {
                    userTypeControl.layer.borderColor = UIColor.redColor().CGColor
                    userTypeControl.layer.borderWidth = 1.0
                }
                self.showAlert("Missing required Fields", message: "Fill in or select the missing field(s) in red" )

            } else {
                //Register the user
                let user = PFUser()
                user.username = usernameTxtField.text
                user.password = passwordTxtField.text
                user["isCustomer"] = isCustomer
                
                user.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? String
                        self.showAlert("Error", message: errorString!)
                    } else {
                        print("Register Successful")
                        
                        if (self.isCustomer == true) {
                            self.presentCustomerVC()
                        } else {
                            self.presentAdminVC()
                        }
                    }
                })
            }
        } else {
            //-----------SignIn-----------
            PFUser.logInWithUsernameInBackground(usernameTxtField.text!, password: passwordTxtField.text!)
            PFUser.logInWithUsernameInBackground(usernameTxtField.text!, password: passwordTxtField.text!, block: { (user, error) -> Void in
                if user != nil {
                    print("Login Successful")
                    self.determineCustomerOrAdmin(user!)
                    
                    if self.isCustomer == true {
                        self.presentCustomerVC()
                    } else {
                        self.presentAdminVC()
                    }
                    
                } else {
                    if let errorString = error?.userInfo["error"] as? String {
                        self.showAlert("Error", message: errorString)
                    }
                }
            })
        }
    }
    
    //Presents the CustomerViewController, customer screen.
    func presentCustomerVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customerVC = storyboard.instantiateViewControllerWithIdentifier("customerVC")
        self.presentViewController(customerVC, animated: true, completion: nil)
    }
    
    //Presents the MapviewController as Tab-bar with AdminTableViewController as another tab.
    func presentAdminVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customerVC = storyboard.instantiateViewControllerWithIdentifier("adminVC")
        self.presentViewController(customerVC, animated: true, completion: nil)
    }
    
    //Determines Signin or Register
    func determineSignInOrRegister() {
        if buttonTitlePressed != nil {
            if buttonTitlePressed == "Sign In" {
                isSignIn = true
                self.navigationController?.title = "Sign In"
            }
        } else {
                self.navigationController?.title = "Register"
                userTypeControl.hidden = false
                isSignIn = false
        }
    }
    
    //Action when user selects the type, Customer or Admin
    @IBAction func userTypeSelected(sender: AnyObject) {
        
        if userTypeControl.selectedSegmentIndex == 0 {
            isCustomer = true
        } else {
            isCustomer = false
        }
    }
    
    //Helper Alert button
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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