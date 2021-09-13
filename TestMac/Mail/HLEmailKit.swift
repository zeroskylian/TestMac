//
//  HLEmailKit.swift
//  TestMac
//
//  Created by lian on 2021/9/13.
//

import Foundation

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
