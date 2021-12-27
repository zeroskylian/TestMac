//
//  DropDownMenu.swift
//  TestMac
//
//  Created by lian on 2021/12/2.
//

import Foundation
import AppKit

class DropdownMenu: NSView {
    
    var dataSource: [String] = []
    
    let titleLabel: NSLabel = {
        let titleLabel = NSLabel()
        titleLabel.isSelectable = false
        titleLabel.textColor = HLColor.hex333333.color
        titleLabel.font = .systemFont(ofSize: 16)
        return titleLabel
    }()
    
    lazy var tableView: HLTableView = {
        let tableView = HLTableView()
        tableView.delegate = self
        tableView.dataSource = self
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("DropdownMenu"))
        tableView.addTableColumn(column)
        tableView.headerView = nil
        tableView.selectionHighlightStyle = .none
        tableView.scrollView.autohidesScrollers = true
        tableView.hlDelegate = self
        return tableView
    }()
    
    /// 当前选中的item
    var selectItem: String?
    
    /// tableview 是否可见
    var isVisable: Bool = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layerBackgroundColor = .white
        cornerRadius = 4
        borderWidth = 1
        borderColor = HLColor.hexBCBFC5.color
        let imageView = NSImageView()
        imageView.image = Asset.bottomArrow.image
        addSubview(imageView)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        let cover = HLImageButton()
        cover.target = self
        cover.action = #selector(dropDownButtonAction)
        addSubview(cover)
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(dataSource: [String], current: String) {
        titleLabel.text = current
        selectItem = current
        self.dataSource = dataSource
    }
    
    func select(at index: Int) {
        guard index > 0, index < dataSource.count else { return }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dropDownButtonAction() {
        guard let window = self.window, let contentView = window.contentView else { return }
        if tableView.scrollView.superview == nil {
            contentView.addSubview(tableView.scrollView)
            let frame = CGRect(x: 0, y: 0, width: self.width, height: CGFloat(min(Int(dataSource.count), 4) * 24))
            var transform = contentView.convert(frame, from: self)
            transform.origin.y -= frame.height
            tableView.scrollView.frame = transform
        }
        if isVisable == false {
            tableView.scrollView.isHidden = false
            isVisable = true
        } else {
            tableView.scrollView.isHidden = true
            isVisable = false
        }
    }
    
    @objc private func onClickTableViewRow() {
        guard tableView.clickedRow > 0 else { return }
    }
}

extension DropdownMenu: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24
    }
}

extension DropdownMenu: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return HLCommonRow(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(name: DropdownMenuCell.self, owner: nil)
        if let item = dataSource.item(at: row) {
            cell?.setSelected(selected: item == selectItem)
            cell?.bind(data: item)
        }
        return cell
    }
}

extension DropdownMenu: HLTableViewDelegate {
    func hlTableViewMouseMove(tableView: HLTableView, event: NSEvent) {
        
    }
    
    func hlTableViewMouseExit(tableView: HLTableView, event: NSEvent) {
        
    }
}

class DropdownMenuCell: NSTableCellView {
    let textLabel: NSLabel = {
        let textLabel = NSLabel()
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.isSelectable = false
        return textLabel
    }()
    
    let selectBackground = NSView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        layerBackgroundColor = .white
        selectBackground.isHidden = true
        selectBackground.layerBackgroundColor = HLColor.hex1890FF.color
        addSubview(selectBackground)
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
        }
        
        selectBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        if let superView = self.superview {
            frame = superView.bounds
        }
    }
    
    func bind(data: String) {
        textLabel.text = data
    }
    
    func setSelected(selected: Bool) {
        selectBackground.isHidden = !selected
        textLabel.textColor = selected ? HLColor.hexFFFFFF.color : HLColor.hex000000.color
    }
}
