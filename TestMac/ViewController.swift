//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
    
    let stackView = NSStackView()
    
    var dataSource: [TabItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        stackView.orientation = .horizontal
        stackView.spacing = 1
        stackView.alignment = .centerY
        stackView.distribution = .fillEqually
    }
    
    @IBAction func addAction(_ sender: NSButton) {
        let  item = TabItem(id: "1", title: "测试", closable: true, view: TabItemView(), vc: TestVc())
        addTab(item: item)
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func delay(seconds: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
    }

    func addTab(item: TabItem) {
        guard dataSource.count <= 0 else { return }
        if dataSource.contains(item) {
            selectTab(item: item)
        } else {
            dataSource.append(item)
        }
    }

    func selectTab(item: TabItem) {
        item.isSelected = true
        dataSource.forEach { tmp in
            if tmp != item {
                tmp.isSelected = true
            }
        }
    }
}

class TabItem {
     
    let view: TabItemView
    
    let viewController: NSViewController
    
    let id: String
    
    let title: String
    
    let closable: Bool
    
    init(id: String, title: String, closable: Bool, view: TabItemView, vc: NSViewController) {
        self.id = id
        self.title = title
        self.closable = closable
        self.view = view
        self.viewController = vc
    }
    
    var isSelected: Bool = false {
        didSet {
            view.setSelected(isSelected: isSelected)
        }
    }
}

// MARK: - Equatable
extension TabItem: Equatable {
    static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        return lhs.id == rhs.id
    }
}

class TabItemView: NSView {
    
    let titleLabel: NSLabel = {
        let titleLabel = NSLabel()
        titleLabel.isSelectable = false
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = NSColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1)
        return titleLabel
    }()
    
    let closeButton: NSButton = {
        let closeButton = NSButton()
        closeButton.isBordered = false
        closeButton.title = "关闭"
        return closeButton
    }()
    
    let selectBg: NSView = {
        let selectBg = NSView()
        selectBg.wantsLayer = true
        selectBg.layer?.backgroundColor = NSColor.cyan.cgColor
        
        let line = NSView()
        line.wantsLayer = true
        line.layer?.backgroundColor = NSColor.blue.cgColor
        selectBg.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        return selectBg
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI() {
        closeButton.target = self
        closeButton.action = #selector(closeAction(_:))
        selectBg.isHidden = true
        addSubview(selectBg)
        addSubview(titleLabel)
        addSubview(closeButton)
        selectBg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.greaterThanOrEqualTo(closeButton.snp.left).offset(-8)
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.centerY.equalToSuperview()
        }
    }
    
    func setSelected(isSelected: Bool) {
        selectBg.isHidden = !isSelected
    }
    
    @objc func closeAction(_ sender: NSButton) {
        
    }
}

class TestVc: NSViewController {
    override func loadView() {
        let view = NSView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        self.view = view
    }
}
