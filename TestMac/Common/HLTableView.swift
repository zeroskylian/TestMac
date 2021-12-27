//
//  HLTableView.swift
//  HengLink_Mac
//
//  Created by lian on 2021/6/28.
//

import AppKit

protocol HLTableViewDelegate: AnyObject {
    func hlTableViewMouseMove(tableView: HLTableView, event: NSEvent)
    
    func hlTableViewMouseExit(tableView: HLTableView, event: NSEvent)
}

@objcMembers class HLTableView: NSTableView {
    
    weak var hlDelegate: HLTableViewDelegate?
    
    lazy var scrollView: HLScrollView = {
        let scrollView = HLScrollView()
        scrollView.backgroundColor = .clear
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        return scrollView
    }()
    
    /// 是否需要鼠标追踪
    var needTrackArea: Bool = false
    
    private var trackingArea: NSTrackingArea?
    
    // MARK: -lifecycle
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    // MARK: - funtions
    func setupUI() {
        if #available(macOS 11.0, *) {
            style = .plain
        }
        allowsColumnResizing = false
        allowsColumnReordering = false
        scrollView.documentView = self
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func keyDown(with event: NSEvent) {
        if event.characters == " " {
            return super.keyDown(with: event)
        }
    }
    
    override func layout() {
        super.layout()
        if needTrackArea {
            trackingArea = NSTrackingArea.init(rect: bounds, options: [.activeAlways, .mouseMoved, .mouseEnteredAndExited], owner: self, userInfo: nil)
            addTrackingArea(trackingArea!)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        hlDelegate?.hlTableViewMouseMove(tableView: self, event: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        hlDelegate?.hlTableViewMouseExit(tableView: self, event: event)
    }
    
    override func becomeFirstResponder() -> Bool {
        return false
    }
}

class HLScrollView: NSScrollView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        autohidesScrollers = true
        scrollerStyle = .overlay
    }
    
    override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)
        if subview is NSVisualEffectView {
            subview.isHidden = true
        }
    }
}
