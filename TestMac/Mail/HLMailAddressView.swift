//
//  HLMailAddressView.swift
//  TestMac
//
//  Created by lian on 2021/9/13.
//

import AppKit

protocol HLMailAddressViewDelegate: AnyObject {
    func mailAddressView(view: HLMailAddressView, add address: String)
}

class HLMailAddressView: NSView, NibLoadable {
    
    weak var delegate: HLMailAddressViewDelegate?
    
    @IBOutlet weak var titleLb: NSTextField!
    
    @IBOutlet weak var inputTextView: HLMailAddressTextView! {
        didSet {
            inputTextView.font = .systemFont(ofSize: 14)
        }
    }
    
    func add(address: HLEmailKit.Address) {
        if let attachment = create(address: address, needAddTrackingArea: false) {
            let attribute = NSAttributedString(attachment: attachment)
            inputTextView.textStorage?.append(attribute)
        }
    }
    
    func create(address: HLEmailKit.Address, needAddTrackingArea: Bool) -> NSTextAttachment? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(address)
            let attachment = NSTextAttachment(data: data, ofType: "mail")
            let cell = HLMailAddressAttachmentCell()
            cell.needAddTrackingArea = needAddTrackingArea
            attachment.attachmentCell = cell
            return attachment
        } catch {
            return nil
        }
    }
}

// MARK: - NSTextViewDelegate
extension HLMailAddressView: NSTextViewDelegate {
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSTextView.insertNewline(_:)) {
//            delegate?.mailAddressView(view: self, add: <#T##String#>)
            return true
        }
        return false
    }
}

class HLMailAddressTextView: NSTextView {
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return super.performKeyEquivalent(with: event)
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}
