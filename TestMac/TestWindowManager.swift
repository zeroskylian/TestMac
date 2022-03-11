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
//        super.newWindowForTab(sender)
        let windowController = self.storyboard?.instantiateInitialController() as? TestWindowManager
        let window = windowController?.window
        window?.windowController = self
        guard let window = window else { return }
        self.window?.addTabbedWindow(window, ordered: .above)
    }
}
