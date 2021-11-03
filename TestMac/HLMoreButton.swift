//
//  HLMoreButton.swift
//  TestMac
//
//  Created by lian on 2021/9/27.
//

import Foundation
import AppKit
import SnapKit

class HLMoreButton: NSView {
    
    lazy var moreButton: NSButton = {
       let button = NSButton(image: NSImage(named: "icon_arrowdown")!, target: self, action: #selector(moreButtonAction))
        button.imagePosition = .imageOnly
        button.isBordered = false
        button.imageScaling = .scaleNone
        return button
    }()
    
    lazy var mainButton: NSButton = {
        let button = NSButton(image: NSImage(named: "icon_phonecall")!, target: self, action: #selector(mainButtonAction))
        button.imagePosition = .imageOnly
        button.isBordered = false
        return button
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(mainButton)
        addSubview(moreButton)
        mainButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        
        moreButton.snp.makeConstraints { make in
            make.left.equalTo(mainButton.snp.right)
            make.size.equalTo(CGSize(width: 8, height: 8))
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func moreButtonAction() {
        print("----")
    }
    
    @objc private func mainButtonAction() {
        print("----1")
    }
    
}
