//
//  LoginViewController.swift
//  WhereYou
//
//  Created by tony huang on 6/27/15.
//  Copyright © 2015 Tony. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField! {
        didSet { usernameTextField.delegate = self }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signup(sender: AnyObject) {
        if let username = usernameTextField.text {
            if validateUsername(username) {
                ParseHelper().name = username
                performSegueWithIdentifier("Show Main", sender: nil)
            } else {
                print("retry that name buddy")
            }
        }
    }
    
    // Returns true if username is valid and available
    func validateUsername(username: String) -> Bool {
        return username != "a"
    }
}
