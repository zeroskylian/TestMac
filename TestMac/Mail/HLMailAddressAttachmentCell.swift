//
//  HLMailAddressAttachmentCell.swift
//  HengLink_Mac
//
//  Created by lian on 2021/9/11.
//

import AppKit

class HLMailAddressAttachmentCell: NSTextAttachmentCell {
    
    var style: Style = .receiver {
        didSet {
            contentView.style = style
        }
    }
    
    var contentView: HLMailTagCellContentView = HLMailTagCellContentView()
    
    override func cellSize() -> NSSize {
        if let address = address {
            let size = address.getName().boundingRect(with: CGSize(width: 1000, height: 50), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: style.font])
            let expand = CGSize(width: ceil(size.width) + 10, height: size.height + 4)
            contentView.size = expand
            return expand
        }
        return .zero
    }
    
    var address: HLEmailKit.Address?
    
    override var attachment: NSTextAttachment? {
        didSet {
            if attachment?.fileType == "mail", let data = attachment?.contents {
                do {
                    let jsonDecoder = JSONDecoder()
                    let address = try jsonDecoder.decode(HLEmailKit.Address.self, from: data)
                    self.address = address
                    contentView.address = address
                } catch {
                    
                }
            }
        }
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        super.draw(withFrame: cellFrame, in: controlView)
        if let control = controlView {
            if control.subviews.contains(contentView) == false {
                control.addSubview(contentView)
            }
            contentView.mm.x = cellFrame.minX
            contentView.mm.y = cellFrame.minY
        }
    }
    
    deinit {
        contentView.removeFromSuperview()
    }
    
    struct Style: RawRepresentable, Equatable {
        let rawValue: String
        
        static let address = Style(rawValue: "address")
        
        static let receiver = Style(rawValue: "receiver")
        
        var font: NSFont {
            switch self {
            case .address:
                return .systemFont(ofSize: 14)
            default:
                return .systemFont(ofSize: 12)
            }
        }
    }
}

class HLMailTagCellContentView: NSView {
    
    var style: HLMailAddressAttachmentCell.Style = .receiver {
        didSet {
            textLb.font = style.font
            switch style {
            case .address:
                selectedBg.isHidden = false
            case .receiver:
                selectedBg.isHidden = true
            default:
                break
            }
        }
    }
    
    var address: HLEmailKit.Address? {
        didSet {
            textLb.text = address?.getName()
        }
    }
    
    var needAddTrackingArea: Bool = false {
        didSet {
            selectedBg.isHidden = needAddTrackingArea
        }
    }
    
    private var labelTrackingArea: NSTrackingArea?
    
    private let selectedBg: NSView = {
        let bg = NSView()
        bg.layerBackgroundColor = .systemBlue
        bg.isHidden = true
        bg.cornerRadius = 4
        return bg
    }()
    
    private let textLb: NSLabel = {
        let textLb = NSLabel()
        #warning("-----")
//        textLb.textColor = HLColor.hex333333.color
        textLb.font = .systemFont(ofSize: 12)
        textLb.isSelectable = false
        textLb.alignment = .center
        return textLb
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(selectedBg)
        addSubview(textLb)
        selectedBg.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(EdgeInsets(top: 0, left: 2, bottom: 0, right: 2))
        }
        
        textLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let tap = NSClickGestureRecognizer(target: self, action: #selector(onClickAddress))
        addGestureRecognizer(tap)
    }
    
    override func layout() {
        super.layout()
        guard needAddTrackingArea == true else { return }
        if let tracking = labelTrackingArea {
            removeTrackingArea(tracking)
        }
        labelTrackingArea = NSTrackingArea(rect: bounds, options: [.mouseMoved, .activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(labelTrackingArea!)
    }
    
    @objc private func onClickAddress() {
        print("----")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        selectedBg.isHidden = true
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        selectedBg.isHidden = false
    }
}
