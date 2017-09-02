//
//  CreateAccountViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 8/15/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa

class CreateAccountViewController: NSViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad();
        
    }
    
    //MARK: IBActions
    @IBAction func signInButtonClicked(_ sender: Any)
    {
        guard let windowController = view.window?.windowController as? MainWindowController else { return; }
        windowController.moveToSignInVC();
    }
}
