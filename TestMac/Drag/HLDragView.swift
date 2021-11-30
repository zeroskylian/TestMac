//
//  HLDragView.swift
//  TestMac
//
//  Created by lian on 2021/9/30.
//

import Foundation
import AppKit

protocol HLDragViewDelegate: AnyObject {
    
    func draggingOverlaySize() -> CGSize
    
    func draggingEntered(for dragView: HLDragView, sender: NSDraggingInfo) -> NSDragOperation
    func performDragOperation(for dragView: HLDragView, sender: NSDraggingInfo) -> Bool
    func pasteboardWriter(for dragView: HLDragView) -> NSPasteboardWriting
}

class HLDragView: NSView {
    
    private let dragThreshold: CGFloat = 3.0
    private var dragOriginOffset = CGPoint.zero
    
    weak var delegate: HLDragViewDelegate?
    
    var contents: HLDragViewContent? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let contents = contents {
                addSubview(contents)
            }
        }
    }
    
    var snapshotItem: HLDragView.SnapshotItem? {
        return contents?.snapshotItem
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
//        registerForDraggedTypes([.fileURL])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let location = convert(event.locationInWindow, from: nil)
        let eventMask: NSEvent.EventTypeMask = [.leftMouseUp, .leftMouseDragged]
        let timeout = NSEvent.foreverDuration
        
        window?.trackEvents(matching: eventMask, timeout: timeout, mode: .eventTracking, handler: { (event, stop) in
            guard let event = event else { return }
            if event.type == .leftMouseUp {
                stop.pointee = true
            } else {
                let movedLocation = convert(event.locationInWindow, from: nil)
                if abs(movedLocation.x - location.x) > dragThreshold || abs(movedLocation.y - location.y) > dragThreshold {
                    stop.pointee = true
                    if let delegate = delegate, let contents = self.contents {
                        let draggingItem = NSDraggingItem(pasteboardWriter: delegate.pasteboardWriter(for: self))
                        let size = delegate.draggingOverlaySize()
                        let bounds = CGRect(origin: .zero, size: size)
                        let content = NSImage(data: contents.dataWithPDF(inside: bounds))
                        draggingItem.setDraggingFrame(bounds, contents: content)
                        beginDraggingSession(with: [draggingItem], event: event, source: self)
                    }
                }
            }
        })
    }
}

extension HLDragView: NSDraggingSource {
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        var result: NSDragOperation = []
        if let delegate = delegate {
            result = delegate.draggingEntered(for: self, sender: sender)
        }
        return result
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return (context == .outsideApplication) ? [.copy] : []
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return delegate?.performDragOperation(for: self, sender: sender) ?? true
    }
}

extension HLDragView {
    enum SnapshotItem {
        case image(name: String, image: NSImage)
        case data(name: String, data: Data)
        case file(name: String?, url: URL)
        
        var name: String {
            switch self {
            case .data(name: let name, data: _):
                return name
            case .image(name: let name, image: _):
                return name
            case .file(name: let name, url: let url):
                if let name = name {
                    return name
                } else {
                    return url.lastPathComponent
                }
            }
        }
    }
}

protocol HLDragViewContent: NSView {
    var snapshotItem: HLDragView.SnapshotItem? { get }
}
