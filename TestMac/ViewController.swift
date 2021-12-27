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
        do {
            let path = Bundle.main.path(forResource: "kg", ofType: "txt")!
            let data = try Data.init(contentsOf: URL(fileURLWithPath: path))
            let string = String(data: data, encoding: .utf8)
            print(string)
            print(string?.utf8)
        } catch {
            print(error)
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
