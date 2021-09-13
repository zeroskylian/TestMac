//
//  EncodableExtension.swift
//  TestMac
//
//  Created by lian on 2021/9/11.
//

import Foundation

extension Encodable {
    func encodeJson<T>() -> T? {
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? T
            return json
        } catch {
            return nil
        }
    }
}
