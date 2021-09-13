//
//  DictionaryExtensions.swift
//  TestMac
//
//  Created by lian on 2021/9/10.
//

import Foundation

extension Dictionary {
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
}
