//
//  AppDelegate.swift
//  SlackClone
//
//  Created by Steve Kerney on 8/15/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa
import Parse

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        //Parse Init
        let configuration = ParseClientConfiguration
        {
            $0.applicationId = "slackcloneserver"
            $0.server = "http://slackcloneserver.herokuapp.com/parse"
        }
        
        Parse.initialize(with: configuration);
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }


}

