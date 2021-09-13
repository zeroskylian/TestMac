//
//  HLMailAddressView.swift
//  TestMac
//
//  Created by lian on 2021/9/13.
//

import AppKit

protocol HLMailAddressViewDelegate: AnyObject {
    func mailAddressView(view: HLMailAddressView, add text: String)
}

class HLMailAddressView: NSView, NibLoadable {
    
    weak var delegate: HLMailAddressViewDelegate?
    
    @IBOutlet weak var titleLb: NSTextField!
    
    @IBOutlet weak var scrollView: NSScrollView!
    
    @IBOutlet weak var inputTextView: HLMailAddressTextView! {
        didSet {
            inputTextView.font = .systemFont(ofSize: 14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(titleLb.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLb)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func add(address: HLEmailKit.Address) {
        if let attachment = address.create(style: .address) {
            let attribute = NSAttributedString(attachment: attachment)
            inputTextView.textStorage?.append(attribute)
        }
    }
    
    func cleanPlainText() {
        inputTextView.string = ""
    }
    
    func getText() -> String {
        return inputTextView.string
    }
}

// MARK: - NSTextViewDelegate
extension HLMailAddressView: NSTextViewDelegate {
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSTextView.insertNewline(_:)) {
            delegate?.mailAddressView(view: self, add: inputTextView.string)
            return true
        }
        return false
    }
}

class HLMailAddressTextView: NSTextView {
    
    override var intrinsicContentSize: NSSize {
        guard let textContainer = self.textContainer,
              let layoutManager = self.layoutManager else {
            return .zero
        }
        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return super.performKeyEquivalent(with: event)
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
    override func didChangeText() {
        super.didChangeText()
        invalidateIntrinsicContentSize()
    }
}
