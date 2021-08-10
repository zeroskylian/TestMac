//
//  NSLabel.swift
//  HengLink_Mac
//
//  Created by lian on 2021/6/28.
//

import AppKit

protocol NSLabelDelegate: AnyObject {
    func labelDidEndEditing()
}

class NSLabel: NSTextField {
    
    weak var labelDelegate: NSLabelDelegate?
    
    var maxLength: Int = 0
    
    var text: String? {
        get {
            return stringValue
        }
        set {
            stringValue = newValue ?? ""
        }
    }
    
    private var labelTrackingArea: NSTrackingArea?
    
    var needAddTrackingArea: Bool = false
    
    var canEdit: Bool = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        font = .systemFont(ofSize: 14)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        isBezeled = false
        drawsBackground = false
        isEditable = false
        isSelectable = true
        delegate = self
        allowsExpansionToolTips = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layout() {
        super.layout()
        guard needAddTrackingArea == true else {
            return
        }
        if let tracking = labelTrackingArea {
            removeTrackingArea(tracking)
        }
        labelTrackingArea = NSTrackingArea(rect: bounds, options: [.mouseMoved, .activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(labelTrackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        nextResponder?.rightMouseDown(with: event)
    }
    
}

// MARK: - NSTextFieldDelegate
extension NSLabel: NSTextFieldDelegate {
    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        labelDelegate?.labelDidEndEditing()
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if let tf = obj.object as? NSLabel, tf == self, maxLength > 0 {
            tf.text = String(tf.stringValue.utf8.prefix(maxLength))
        }
    }
}

// MARK: - NSTextViewDelegate
extension NSLabel: NSTextViewDelegate {
    func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        return nil
    }
}
