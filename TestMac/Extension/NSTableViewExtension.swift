//
//  NSTableViewExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/6/30.
//

import AppKit

extension NSTableView {
    
    var visibleRows: NSRange {
        return rows(in: visibleRect)
    }
    
    func scrollRowToVisible(row: Int, animated: Bool) {
        if animated {
            let rowRect = self.rect(ofRow: row)
            var scrollOrigin = rowRect.origin
            let clipView = self.superview as? NSClipView
            
            let tableHalfHeight = clipView!.frame.height * 0.5
            let rowRectHalfHeight = rowRect.height * 0.5
            
            scrollOrigin.y = (scrollOrigin.y - tableHalfHeight) + rowRectHalfHeight
            let scrollView = clipView!.superview as? NSScrollView
            
            if scrollView!.responds(to: #selector(NSScrollView.flashScrollers)) {
                scrollView!.flashScrollers()
            }
            
            clipView!.animator().setBoundsOrigin(scrollOrigin)
        } else {
            self.scrollRowToVisible(row)
        }
    }
    
    func registerNib<T: NSView>(name: T.Type) {
        register(NSNib(nibNamed: String(describing: name), bundle: Bundle.main), forIdentifier: NSUserInterfaceItemIdentifier(String(describing: name)))
    }
    
    func makeView<T: NSView>(name: T.Type, owner: Any?) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: name))
        var cell = makeView(withIdentifier: identifier, owner: owner) as? T
        if cell == nil {
            cell = T(frame: CGRect(x: 0, y: 0, width: width, height: 50))
            cell?.identifier = identifier
        }
        return cell
    }
}
