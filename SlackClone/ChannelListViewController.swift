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
    //Window Controller
    var addChannelWC: NSWindowController?;
    
    //MARK: IBOutlets
    @IBOutlet weak var profilePictureImageView: NSImageView!
    @IBOutlet weak var nameLabel: NSTextField!
    
    //User Info
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        

        
        
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear();
        

        updateUserUIElems();
    }
    
     //MARK: IBActions
    @IBAction func logoutButtonClicked(_ sender: Any)
    {
        PFUser.logOut();
        guard let windowController = view.window?.windowController as? MainWindowController else { return; }
        windowController.moveToSignInVC();
    }
    
    @IBAction func addChannelButtonClicked(_ sender: Any)
    {
        addChannelWC = storyboard?.instantiateController(withIdentifier: channelListWCIdentifier) as? NSWindowController;
        addChannelWC?.showWindow(nil);
        
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
}
