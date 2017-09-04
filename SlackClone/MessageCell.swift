//
//  MessageCell.swift
//  SlackClone
//
//  Created by Steve Kerney on 9/4/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import Cocoa

class MessageCell: NSTableCellView
{
    //MARK: IBOutlets
    @IBOutlet weak var userImageView: NSImageView!
    @IBOutlet weak var userNameLabel: NSTextField!
    @IBOutlet weak var messageDateLabel: NSTextField!
    @IBOutlet weak var messageTextLabel: NSTextField!
    

    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
