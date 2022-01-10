//
//  FileFragment.swift
//  TestMac
//
//  Created by lian on 2022/1/8.
//

import Foundation
import CryptoKit
import CommonCrypto

class HLFileInfo {
    
    let url: URL
    
    let filename: String
    
    lazy var data: Data? = {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }()
    
    let fileSize: Int
    
    var offset: Int
    
//    let mimeType: String {
//        return url.mimeType
//    }
    
    init?(url: URL, offset: Int) {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        self.url = url
        self.filename = url.lastPathComponent
        self.offset = offset
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = (attributes[.size] as? Int ) ?? 0
        } catch {
            fileSize = 0
        }
    }
    
    func getFileSlice() {
        
    }
}

class HLFileInfoSlice {
    
    let data: Data
    
    let range: Range<Data.Index>
    
    lazy var md5: String = {
        return data.md5
    }()

    init(data: Data, range: Range<Data.Index>) {
        self.data = data
        self.range = range
        
    }
}

extension Data {
    var md5 : String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(self.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}
