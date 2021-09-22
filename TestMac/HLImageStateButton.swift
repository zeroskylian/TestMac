//
//  HLImageStateButton.swift
//  TestMac
//
//  Created by lian on 2021/9/18.
//

import AppKit

class HLImageStateButton: NSButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        isBordered = false
        imagePosition = .imageOnly
        bezelStyle = .regularSquare
    }
    
    private var stateColors: [NSControl.StateValue: NSColor] = [:]
    
    func set(backbroundcolor: NSColor, state: NSControl.StateValue) {
        stateColors[state] = backbroundcolor
    }
    
    func backbroundcolor(for state: NSControl.StateValue) -> NSColor? {
        return stateColors[state]
    }
    
    override var state: NSControl.StateValue {
        didSet {
            if let color = backbroundcolor(for: state) {
                layerBackgroundColor = color
            }
        }
    }
}
