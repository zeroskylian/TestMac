//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import SnapKit
import WebKit
import Alamofire

class ViewController: NSViewController {
    let tv = HLMailAddressView.createFromNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view.addSubview(tv)
        tv.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(52)
            make.height.equalTo(44)
        }
    }
    @IBAction func addtag(_ sender: Any) {
        let mail = HLEmailKit.Address(name: "廉鑫博", mail: "lianxinbo@hengli.com")
        tv.add(address: mail)
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

