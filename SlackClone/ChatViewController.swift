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
    var messages: [PFObject] = [];
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageTextField.delegate = self;
        
        
    }
    
    override func viewWillAppear()
    {
        clearUI();
    }
    
    //MARK: IBActions
    @IBAction func sendButtonClicked(_ sender: Any)
    {
        //Valid Channel?
        guard let vSelectedChannel = selectedChannel else {  print("No channel was selected, cannot send message."); return; }
        
        //Message Creation
        let messageObject = PFObject(className: "Message");
        
        //Message Text
        guard !messageTextField.stringValue.isEmpty else { print("Message text was empty."); return; }
        messageObject["text"] = messageTextField.stringValue;
        
        //Message Sender
        messageObject["user"] = PFUser.current();
        
        //Message's Channel
        messageObject["channelOwner"] = vSelectedChannel;
        
        //Commit to DB
        messageObject.saveInBackground { (success, error) in
            
            guard error == nil, success else { print(error!.localizedDescription); return; }
            
            print("Message written to DB.");
            
            self.messageTextField.stringValue = "";
            self.retrieveChannelMessages();
        }
    }
}

//Messages TableView
extension ChatViewController: NSTableViewDataSource, NSTableViewDelegate
{
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return messages.count;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        guard let messageCell = tableView.make(withIdentifier: messageCellIdentifier, owner: nil) as? MessageCell else { return NSTableCellView(); }
        
        guard row >= 0 else { return NSTableCellView(); }
        let message = messages[row];
        
        //Message Text
        guard let vMessageText = message["text"] as? String else { return NSTableCellView(); }
        messageCell.messageTextLabel.stringValue = vMessageText;
        
        //Message Date
        guard let vDateCreated = message.createdAt else { return NSTableCellView(); }
        let formatter = DateFormatter();
        formatter.dateFormat = "MMM d h:mm a";
        let formattedDate = formatter.string(from: vDateCreated);
        messageCell.messageDateLabel.stringValue = formattedDate;
        
        //Message Sender
        guard let vMessageSender = message["user"] as? PFUser else { return NSTableCellView(); }
        guard let vMessageSenderUserName = vMessageSender["name"] as? String else { return NSTableCellView(); }
        messageCell.userNameLabel.stringValue = vMessageSenderUserName;
        
        //Message Sender's Profile Pic
        guard let vMessageSenderProfilePic = vMessageSender["profilePic"] as? PFFile else { return NSTableCellView(); }
        vMessageSenderProfilePic.getDataInBackground { (data, error) in
            
            guard error == nil else { print(error!.localizedDescription); return;}
            guard let vData = data else { return; }
            guard let vImage = NSImage(data: vData) else { return; }
            messageCell.userImageView.image = vImage;
        }
        
        return messageCell;
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 100.0;
    }
}

//MARK: Helper funcs
extension ChatViewController
{
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
        
        retrieveChannelMessages();
        
    }
    
    func retrieveChannelMessages()
    {
        guard let vSelectedChannel = selectedChannel else { print("No channel selected."); return; }
        
        let messagesQuery = PFQuery(className: "Message");
        messagesQuery.includeKey("user");
        messagesQuery.whereKey("channelOwner", equalTo: vSelectedChannel);
        messagesQuery.addAscendingOrder("createdAt");
        
        messagesQuery.findObjectsInBackground { (messages, error) in
            guard error == nil else { print(error!.localizedDescription); return; }
            
            guard let vMessages = messages else { return; }
            
            print("Messages retrieved.");
            self.messages = vMessages;
            self.tableView.reloadData();
            self.tableView.scrollRowToVisible(self.messages.count - 1);
        }
    }
    
    fileprivate func clearUI()
    {
        selectedChannel = nil;
        messages = [];
        tableView.reloadData();
        channelNameLabel.stringValue = "";
        channelDescriptionLabel.stringValue = "";
        messageTextField.placeholderString = "";
    }
}

//Keyboard Events
extension ChatViewController: NSTextFieldDelegate
{
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool
    {
        if commandSelector == #selector(insertNewline(_:))
        {
            sendButtonClicked(self);
        }
        
        return false;
    }
}
