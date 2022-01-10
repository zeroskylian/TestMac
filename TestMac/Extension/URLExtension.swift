//
//  URLExtension.swift
//  TestMac
//
//  Created by lian on 2022/1/10.
//

import Foundation
import CoreServices

extension URL {
    var mimeType: String? {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        return nil
    }
}
