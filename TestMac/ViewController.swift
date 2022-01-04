//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import SwiftSoup
import EFQRCode

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageview = NSImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(imageview)
        
        if let image = EFQRCode.generate(for: "https://www.baidu.com") {
            let nsImage = NSImage.init(cgImage: image, size: CGSize(width: 100, height: 100))
            imageview.image = nsImage
        }
        
        
        let stackView = DraggingStackView(frame: CGRect(x: 0, y: 100, width: 300, height: 300))
        [NSColor.red, NSColor.blue, .cyan].forEach { color in
            let v = NSView()
            v.layerBackgroundColor = color
            stackView.addArrangedSubview(v)
        }
        stackView.orientation = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        view.addSubview(stackView)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
