//
//  TestWindowManager.swift
//  TestMac
//
//  Created by lian on 2022/1/12.
//

import AppKit

class TestWindowManager: NSWindowController {
    
    override init(window: NSWindow?) {
        super.init(window: window)
        window?.tabbingMode = .automatic
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        window?.tabbingMode = .automatic
    }
    
    override func newWindowForTab(_ sender: Any?) {
        super.newWindowForTab(sender)
        print(sender)
    }
}
