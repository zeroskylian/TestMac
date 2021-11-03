//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import SwiftSoup

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let html = "<div style=\"font-family: Arial;\"><div style=\"font-family:Arial;\">\n\t<div style=\"font-family:Arial;\">\n\t\tasdasdasd<img src=\"/coremail/s?func=mbox:getComposeData&amp;sid=BAqFYtEEMFqPaASrVsEEgPzcxhqSkCnt&amp;composeId=1632363392253&amp;attachId=1\" alt=\"\">sadasdasdas<br>\n<br>\nasdasd<br>\n\t\t<blockquote class=\"ReferenceQuote\" style=\"padding-left:5px;margin-left:5px;border-left:#b6b6b6 2px solid;margin-right:0;\">\n\t\t\t-----原始邮件-----<br>\n<b>发件人:</b><span id=\"rc_from\">\"桑原野\" &lt;zhengxinqi@delicf.com&gt;</span><br>\n<b>发送时间:</b><span id=\"rc_senttime\">2021-09-17 10:45:22 (星期五)</span><br>\n<b>收件人:</b> zhengxinqi@delicf.com<br>\n<b>抄送:</b> <br>\n<b>主题:</b> Test0917000000005<br>\n<br>\nEeeeeeeeeeeeeee\n发自HENGLINK\n\t\t</blockquote>\n\t</div>\n</div></div>"
        do {
            guard let doc: Document = try? SwiftSoup.parse(html) else { return }
            let srcs: Elements = try doc.select("img[src]")
            srcs.forEach { elem in
                do {
                    let oldValue = try elem.attr("src")
                    try elem.attr("src", oldValue + "&lina")
                } catch {
                    
                }
            }
//            print(doc)
        } catch {
            print(error)
        }
        
        drag.layerBackgroundColor = .red
        view.addSubview(drag)
        
        let gesture = NSPanGestureRecognizer(target: self, action: #selector(gestureAction(gesture:)))
        gesture.delaysOtherMouseButtonEvents = true
        drag.addGestureRecognizer(gesture)
    }
    let drag = HLDragView(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
    
    var beginPoint = CGPoint(x: 0, y: 100)
    
    @objc private func gestureAction(gesture: NSPanGestureRecognizer) {
        switch gesture.state {
        case .possible:
            break
        case .began:
            beginPoint = drag.center
        case .changed:
            let location = gesture.location(in: self.view)
            print(location)
            let translation = gesture.translation(in: self.view)
            
//            let origin = drag.frame
//            let frame = CGRect(x: beginPoint.x + translation.x, y: beginPoint.y + translation.y, width: origin.width, height: origin.height)
//            print(frame)
            let center = CGPoint(x: beginPoint.x + translation.x, y: beginPoint.y + translation.y)
            drag.center = center
//            drag.frame = frame
        case .ended:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    @IBOutlet var textView: RichTextView! {
        didSet {
            textView.richDelegate = self
        }
    }
    
    let richText: HLRichText = HLRichText()
    
    
    @IBOutlet weak var italic: HLImageStateButton! {
        didSet {
            italic.set(backbroundcolor: .clear, state: .off)
            italic.set(backbroundcolor: .red, state: .on)
        }
    }
    
    @IBOutlet weak var fontSizeButton: NSPopUpButton! {
        didSet {
            fontSizeButton.removeAllItems()
            fontSizeButton.addItems(withTitles: (1 ... 20).map({ i in
                return "\(i) px"
            }))
        }
    }
    
    @IBAction func changeFont(_ sender: NSButton) {
        
    }
    
    
    @IBAction func fontSizeChangeAction(_ sender: NSPopUpButton) {
        let size = fontSizeButton.indexOfSelectedItem + 1
        richText.fontSize = CGFloat(size)
    }
    
    @IBAction func changeColor(_ sender: NSButton) {
        guard let window = view.window else { return }
        let colorPanel = NSColorPanel.shared
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(selectColor(panel:)))
        colorPanel.setFrameOrigin(sender.frame.origin)
        let pointOnScreen = window.convertToScreen(sender.frame)
        colorPanel.setFrameOrigin(CGPoint(x: pointOnScreen.midX - sender.width / 2.0, y: pointOnScreen.minY - colorPanel.frame.height))
        colorPanel.orderFront(nil)
        colorPanel.mode = .colorList
    }
    
    @objc func selectColor(panel: NSColorPanel) {
        print(panel.color)
        richText.textColor = panel.color
        
    }

    @IBAction func setFontBold(_ sender: NSButton) {
        richText.bold.toggle()
        sender.state = .off
    }
    
    @IBAction func setFontItalic(_ sender: NSButton) {
        richText.italic.toggle()
        sender.state = .on
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.state = .off
        }
        
    }
    
    
    @IBAction func setFontUnderline(_ sender: NSButton) {
        richText.italic.toggle()
        sender.state = richText.italic ? .on : .off
    }
    
    @IBAction func setFontStrikethrough(_ sender: NSButton) {
        richText.strikethrough.toggle()
    }
    
    
    
    @IBAction func addtag(_ sender: Any) {
        guard let attrStr = textView.textStorage else { return }
        let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .excludedElements: ["html", "head", "body"]]
        do {
            let htmlData = try attrStr.data(from: NSMakeRange(0, attrStr.length), documentAttributes:documentAttributes)
            if let htmlString = String(data:htmlData, encoding: .utf8) {
                print(htmlString)
                print("----")
            }
            
        } catch {
            print("error creating HTML from Attributed String")
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func delay(seconds: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
    }
}

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
