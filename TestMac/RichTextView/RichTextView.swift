//
//  RichTextView.swift
//  TestMac
//
//  Created by lian on 2021/11/30.
//

import AppKit

protocol RichTextViewDelegate: AnyObject {
    func richTextView(textView: RichTextView, insert text: Any) -> Any
}

class RichTextView: NSTextView {

    weak var richDelegate: RichTextViewDelegate?
    
    override func insertText(_ string: Any, replacementRange: NSRange) {
        if let insertText = richDelegate?.richTextView(textView: self, insert: string) {
            super.insertText(insertText, replacementRange: replacementRange)
        } else {
            super.insertText(string, replacementRange: replacementRange)
        }
    }
}

class HLRichText {
    var font: NSFont = .systemFont(ofSize: 12)
    var fontSize: CGFloat = 12
    var textColor: NSColor = .red
    var bold: Bool = false
    var italic: Bool = false
    var underline: Bool = false
    var strikethrough: Bool = false
    
    var innerFont: NSFont {
        var font = NSFont(descriptor: self.font.fontDescriptor, size: self.fontSize)
        if bold {
            font = NSFontManager.shared.convert(font!, toHaveTrait: .boldFontMask)
        }
        if italic {
            font = NSFontManager.shared.convert(font!, toHaveTrait: .italicFontMask)
        }
        return font!
    }
    
    func formatter(string: String) -> NSAttributedString {
        var attribute: [NSAttributedString.Key : Any] = [.font: innerFont, .foregroundColor: textColor]
        if strikethrough {
            attribute[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        
        if underline {
            attribute[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        let attributeString = NSMutableAttributedString(string: string, attributes: attribute)
        return attributeString
    }
}

/*
// MARK: - RichTextViewDelegate
extension ViewController: RichTextViewDelegate {
    func richTextView(textView: RichTextView, insert text: Any) -> Any {
        if let string = text as? String {
            let attr = richText.formatter(string: string)
            return attr
        }
        return text
    }
}
*/
