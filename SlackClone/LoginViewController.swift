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
        super.viewDidLoad();
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(50)) { self.updateWindowFrame(); }
    }
    
    override func viewDidAppear()
    {
        updateWindowFrame();
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
        guard !emailTextField.stringValue.isEmpty, !passwordTextField.stringValue.isEmpty else { print("Enter your info 1st."); return; }

        PFUser.logInWithUsername(inBackground: emailTextField.stringValue, password: passwordTextField.stringValue) { (user, error) in
            
            guard error == nil else { print(error!.localizedDescription); return; }
            print("User logged in.");
            guard let windowController = self.view.window?.windowController as? MainWindowController else { return; }
            windowController.moveToChatSplitVC();
        }
    }
    
    fileprivate func updateWindowFrame()
    {
        guard var vFrame = view.window?.frame else { return; }
        
        vFrame.size = CGSize(width: loginWindowWidth, height: loginWindowHeight);
        view.window?.setFrame(vFrame, display: true, animate: true);
    }
}
