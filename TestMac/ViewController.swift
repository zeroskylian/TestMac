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
        
        let url = URL(fileURLWithPath: "/Users/a1/Downloads/PreloadDemo-main.zip")
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            let fileData = try Data(contentsOf: url)
            let fileSize = fileData.count
            print(fileSize)
            let trunkCount = Int(ceil(Double(fileSize) / Double(offset)))
            print(trunkCount)
            var ptr = 0
            var merger = Data()
            for i in 0 ..< trunkCount {
                if i == trunkCount - 1 {
                    let range = ptr ..< fileSize
                    let data = fileData.subdata(in: range)
                    print(range)
                    merger.append(data)
                } else {
                    let range = ptr ..< (ptr + offset)
                    let data = fileData.subdata(in: range)
                    print(range)
                    merger.append(data)
                }
                ptr += offset;
            }
            try merger.write(to: URL(fileURLWithPath: "/Users/a1/Downloads/1.zip"))
        } catch {
            print(error)
        }
        
        
    }
    let offset: Int = 1024 * 1024
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
