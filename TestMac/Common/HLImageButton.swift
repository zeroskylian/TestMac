//
//  HLImageButton.swift
//  HengLink_Mac
//
//  Created by lian on 2021/7/14.
//

import AppKit

class HLImageButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isBordered = false
        imagePosition = .imageOnly
        bezelStyle = .regularSquare
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isBordered = false
        imagePosition = .imageOnly
        bezelStyle = .regularSquare
    }
}
