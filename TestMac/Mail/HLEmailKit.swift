//
//  HLEmailKit.swift
//  TestMac
//
//  Created by lian on 2021/9/13.
//

import AppKit

struct HLEmailKit {
    struct Address: Codable {
        var name: String?
        let mail: String
        
        init(name: String?, mail: String) {
            self.name = name
            self.mail = mail
        }
        
        func getName() -> String {
            return name ?? mail
        }
        
        func toMailBox() -> String {
            if let name = self.name, name != mail {
                return #""\#(name)" <\#(mail)>"#
            } else {
                return mail
            }
        }
    }
}

extension HLEmailKit.Address {
    func create(style: HLMailAddressAttachmentCell.Style) -> NSTextAttachment? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            let attachment = NSTextAttachment(data: data, ofType: "mail")
            let cell = HLMailAddressAttachmentCell()
            cell.style = style
            attachment.attachmentCell = cell
            return attachment
        } catch {
            return nil
        }
    }
}
