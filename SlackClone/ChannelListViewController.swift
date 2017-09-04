//
//  ChannelListViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 9/3/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa
import Parse

class ChannelListViewController: NSViewController
{
    //Window Controllers
    var addChannelWC: NSWindowController?;
    var chatVC: ChatViewController?;
    
    //MARK: IBOutlets
    //User Info
    @IBOutlet weak var profilePictureImageView: NSImageView!
    @IBOutlet weak var nameLabel: NSTextField!
    
    //Channel List
    @IBOutlet weak var tableView: NSTableView!
    var channels: [PFObject] = [];
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear();
        updateUserUIElems();
        retrieveChannelList();
    }
    
    //MARK: IBActions
    @IBAction func logoutButtonClicked(_ sender: Any)
    {
        chatVC?.stopMessageTimer();
        PFUser.logOut();
        guard let windowController = view.window?.windowController as? MainWindowController else { return; }
        windowController.moveToSignInVC();
    }
    
    @IBAction func addChannelButtonClicked(_ sender: Any)
    {
        addChannelWC = storyboard?.instantiateController(withIdentifier: channelListWCIdentifier) as? NSWindowController;
        addChannelWC?.showWindow(nil);
        addChannelWC?.window?.delegate = self;
    }
}

extension ChannelListViewController: NSTableViewDelegate, NSTableViewDataSource
{
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return channels.count;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        guard let channelCell = tableView.make(withIdentifier: channelCellIdentifier, owner: nil) as? NSTableCellView else { return NSTableCellView(); }
        
        guard row >= 0 else { return NSTableCellView(); }
        let channel = channels[row];
        guard let vChannelName = channel["title"] as? String else { return NSTableCellView(); }
        channelCell.textField?.stringValue = "#\(vChannelName)";
        
        return channelCell;
    }
    
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        guard tableView.selectedRow >= 0 else { return; }
        let selectedChannel = channels[tableView.selectedRow];
        
        chatVC?.updateWithChannel(channel: selectedChannel);
    }
}

extension ChannelListViewController
{
    //MARK: Helper Funcs
    fileprivate func updateUserUIElems()
    {
        //Name
        guard let vCurrentUser = PFUser.current() else { return; }
        guard let vName = vCurrentUser["name"] as? String else { return; }
        nameLabel.stringValue = vName;
        
        //Profile Picture
        guard let vProfilePic = vCurrentUser["profilePic"] as? PFFile else { return; }
        vProfilePic.getDataInBackground { (data, error) in
            
            guard error == nil else { print(error!.localizedDescription); return;}
            guard let vData = data else { return; }
            guard let vImage = NSImage(data: vData) else { return; }
            self.profilePictureImageView.image = vImage;
        }
    }
    
    fileprivate func retrieveChannelList()
    {
        let channelQuery = PFQuery(className: "Channel");
        channelQuery.order(byAscending: "title");
        channelQuery.findObjectsInBackground { (channels, error) in
            
            guard error == nil else { print(error!.localizedDescription); return; }
            
            guard let vChannels = channels else { return; }
            print("Channels retrieved.");
            self.channels = vChannels;
            self.tableView.reloadData();
        }
    }
}

extension ChannelListViewController: NSWindowDelegate
{
    func windowWillClose(_ notification: Notification) { retrieveChannelList(); }
}
