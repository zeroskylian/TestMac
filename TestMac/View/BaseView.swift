//
//  BaseView.swift
//  TestMac
//
//  Created by lian on 2022/1/18.
//

import AppKit

class BaseView: NSView {
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        window?.makeFirstResponder(nil)
    }
}
