//
//  HLDragView.swift
//  TestMac
//
//  Created by lian on 2021/9/30.
//

import Foundation
import AppKit

class HLDragView: NSView {
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        let locationInWindow = event.locationInWindow
        let point = convert(locationInWindow, from: nil)
//        print(point)
    }
}
