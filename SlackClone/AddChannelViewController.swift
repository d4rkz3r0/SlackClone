//
//  AddChannelViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 9/3/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa
import Parse

class AddChannelViewController: NSViewController
{
    //MARK: IBOutlets
    
    @IBOutlet weak var channelNameTextField: NSTextField!
    @IBOutlet weak var channelDescriptionTextField: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func addChannelButtonClicked(_ sender: Any)
    {
        guard !channelNameTextField.stringValue.isEmpty, !channelDescriptionTextField.stringValue.isEmpty else { print("Add some channel info 1st."); return; }
        let newChannel = PFObject(className: "Channel");
        newChannel["title"] = channelNameTextField.stringValue;
        newChannel["descrip"] = channelDescriptionTextField.stringValue;
        newChannel.saveInBackground { (success, error) in
            
            guard error == nil, success else { print(error!.localizedDescription); return; }
            
            print("Channel Created.");
            self.view.window?.close();
            
            
        }
    }
}
