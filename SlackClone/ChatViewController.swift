//
//  ChatViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 9/3/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa
import Parse

class ChatViewController: NSViewController
{

    //MARK: IBOutlets
    @IBOutlet weak var channelNameLabel: NSTextField!
    @IBOutlet weak var channelDescriptionLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var messageTextField: NSTextField!
    
    //Channel Info
    var selectedChannel: PFObject?;
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    //MARK: IBActions
    
    @IBAction func sendButtonClicked(_ sender: Any)
    {
        
    }
    
    //MARK: Helper funcs
    func updateWithChannel(channel: PFObject)
    {
        selectedChannel = channel;
        
        //Name
        guard let vChannelName = channel["title"] as? String else { return; }
        let formattedChannelName = "#\(vChannelName)";
        channelNameLabel.stringValue = formattedChannelName;
        
        //Description
        guard let vChannelDescription = channel["descrip"] as? String else { return; }
        channelDescriptionLabel.stringValue = vChannelDescription;
        
        //TextField
        messageTextField.placeholderString = "Message \(formattedChannelName)";
        
    }
    
}

extension ChatViewController: NSTableViewDataSource, NSTableViewDelegate
{
    
}
