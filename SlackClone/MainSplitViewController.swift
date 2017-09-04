//
//  MainSplitViewController.swift
//  SlackClone
//
//  Created by Steve Kerney on 9/2/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad();
        updateWindowFrame();
    }
    
    override func viewDidAppear()
    {
        guard let vChannelListVC = splitViewItems[0].viewController as? ChannelListViewController else { return; }
        guard let vChatVC = splitViewItems[1].viewController as? ChatViewController else { return; }
        
        vChannelListVC.chatVC = vChatVC;
        updateWindowFrame();
    }
    
    fileprivate func updateWindowFrame()
    {
        guard var vFrame = view.window?.frame else { return; }
        
        vFrame.size = CGSize(width: chatWindowWidth, height: chatWindowHeight);
        view.window?.setFrame(vFrame, display: true, animate: true);
    }
}
