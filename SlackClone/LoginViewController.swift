//
//  LoginViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 8/15/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa
import Parse

class LoginViewController: NSViewController
{

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    //MARK: IBActions
    @IBAction func createAccountButtonClicked(_ sender: Any)
    {
        guard let windowController = view.window?.windowController as? MainWindowController else { return; }
        windowController.moveToCreateAccountVC();
        
    }
    
    //Log a User in
    @IBAction func loginButtonClicked(_ sender: Any)
    {
        PFUser.logInWithUsername(inBackground: emailTextField.stringValue, password: passwordTextField.stringValue) { (user, error) in
            
            guard error == nil else { print(error!.localizedDescription); return; }
            print("User logged in.");
            guard let windowController = self.view.window?.windowController as? MainWindowController else { return; }
            windowController.moveToChatSplitVC();
        }
    }
    
}

