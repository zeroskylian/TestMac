//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import Combine
import Kingfisher

class ViewController: NSViewController {
    
    @IBOutlet weak var dd: NSSearchField! {
        didSet {
            dd.borderColor = NSColor.red
            dd.borderWidth = 2
        }
    }
    
    @IBOutlet weak var fff: NSTextField! {
        didSet {
            fff.borderColor = NSColor.red
            fff.borderWidth = 2
            
            let attachment = NSTextAttachment(data: Data(), ofType: nil)
            attachment.attachmentCell = HLChatHistorySearchDateCell()
            let attributeString = NSMutableAttributedString(attachment: attachment)
            fff.attributedStringValue = attributeString
        }
    }
    
    
    @IBOutlet weak var pg: NSProgressIndicator!
    
    let publisher = PassthroughSubject<Date,Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    let queue = OperationQueue()
    var iv = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.iv += 1
            self.pg.doubleValue = Double(self.iv * 10)
            print(self.pg.doubleValue)
        }.fire()
        self.pg.startAnimation(nil)
    }

    func addPb() {
        publisher.throttle(for: .milliseconds(500), scheduler: DispatchQueue.main, latest: false).sink { finish in
            print(finish)
        } receiveValue: { date in
            print("throttle:\t" + "\(date.timeIntervalSince1970)")
        }.store(in: &subscriptions)
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        publisher.send(Date())
        
//        self.view.window?.windowController?.newWindowForTab(nil)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}

class AppMainTabbarSearchField: NSSearchField {
    
    var becomingFirstResponder: (() -> Void)?
    
    override func becomeFirstResponder() -> Bool {
        becomingFirstResponder?()
        return super.becomeFirstResponder()
    }
}
public func check<P: Publisher>(_ title: String, publisher: () -> P) -> AnyCancellable {
    print("----- \(title) -----")
    defer { print("") }
    return publisher()
        .print()
        .sink(
            receiveCompletion: { _ in},
            receiveValue: { _ in }
        )
}

class HLChatHistorySearchDateCell: NSTextAttachmentCell {
    
    let label: NSLabel = {
        let label = NSLabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = NSColor.black
        label.isSelectable = false
        label.layerBackgroundColor = NSColor.red
        return label
    }()
    
    override func cellSize() -> NSSize {
        return CGSize(width: 50, height: 28)
    }
    
    override var attachment: NSTextAttachment? {
        didSet {
//            label.text = "======="
            title = "========"
        }
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        super.draw(withFrame: cellFrame, in: controlView)
        guard let controlView = controlView else { return }
//        if controlView.subviews.contains(label) == false {
//            controlView.addSubview(label)
//        }
        label.size = cellSize()
        label.mm.x = cellFrame.minX
        label.mm.y = 0
    }
    
    deinit {
        label.removeFromSuperview()
    }
}
