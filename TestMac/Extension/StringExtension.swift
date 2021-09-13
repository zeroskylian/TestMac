//
//  StringExtension.swift
//  TestMac
//
//  Created by lian on 2021/9/11.
//

import Foundation

extension String {
    func boundingRect(with size: CGSize, options: NSString.DrawingOptions, attributes: [NSAttributedString.Key : Any]?) -> CGSize {
        return (self as NSString).boundingRect(with: size, options: options, attributes: attributes).size
    }
}
