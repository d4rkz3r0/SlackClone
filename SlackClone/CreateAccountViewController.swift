//
//  CreateAccountViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 8/15/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa
import Parse

class CreateAccountViewController: NSViewController
{
    //MARK: IBOutlets
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var userImageView: NSImageView!
    
    //User Info
    var profileProfilePicFile: PFFile?;
    
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
    
    @IBAction func setImageButtonClicked(_ sender: Any)
    {
        let openPanel = NSOpenPanel();
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        openPanel.canCreateDirectories = true;
        
        openPanel.begin { (result) in
            
            guard result == NSFileHandlingPanelOKButton else { return; }
            guard let vFileURL = openPanel.urls.first else { return; }
            guard let vImage = NSImage(contentsOf: vFileURL) else { return; }
            self.userImageView.image = vImage;
            
            let profilePicPNGData = self.pngDataFrom(image: vImage);
            self.profileProfilePicFile = PFFile(data: profilePicPNGData);
            self.profileProfilePicFile?.saveInBackground();
        }
    }
    
    //User Account Creation
    @IBAction func createAccountButtonClicked(_ sender: Any)
    {
        //Just in case...
        PFUser.logOut();
        
        let newUser = PFUser();
        newUser.username = emailTextField.stringValue;
        newUser.email = emailTextField.stringValue;
        newUser.password = passwordTextField.stringValue;
        newUser["name"] = nameTextField.stringValue;
        newUser["profilePic"] = profileProfilePicFile;
        
        newUser.signUpInBackground { (success, error) in
            
            guard error == nil else { print(error!.localizedDescription); return; }
            guard success else { return; }
            print("User created!");
            
            guard let windowController = self.view.window?.windowController as? MainWindowController else { return; }
            windowController.moveToChatSplitVC();
        }
    }
}

extension CreateAccountViewController
{
    fileprivate func pngDataFrom(image: NSImage) -> Data
    {
        guard let vCGImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { fatalError(); }
        let bitmapData = NSBitmapImageRep(cgImage: vCGImage);
        guard let vPNGData = bitmapData.representation(using: NSBitmapImageFileType.PNG, properties: [:]) else { fatalError(); }
        
        return vPNGData;
    }
}
