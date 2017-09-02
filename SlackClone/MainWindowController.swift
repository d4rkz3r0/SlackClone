//
//  MainWindowController.swift
//  SlackClone
//
//  Created by Steve Kerney on 8/15/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{

    //View Controller Refs
    var loginWindowVC: LoginViewController?;
    var createAccountWindowVC: CreateAccountViewController?;
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        
        loginWindowVC = contentViewController as? LoginViewController;
    
    }
    
    func moveToCreateAccountVC()
    {
        if createAccountWindowVC == nil
        {
            createAccountWindowVC = storyboard?.instantiateController(withIdentifier: createAccountVCIdentifier) as? CreateAccountViewController;
        }
        
        guard let vCreateAccountVC = createAccountWindowVC else { print("Create Acc VC was never created."); return; }
        window?.contentView = vCreateAccountVC.view;
    }
    
    func moveToSignInVC()
    {
        guard let vSignInVC = loginWindowVC else { print("Login VC was invalid."); return; }
        window?.contentView = vSignInVC.view;
    }
}
