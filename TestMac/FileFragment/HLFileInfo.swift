//
//  HLFileInfo.swift
//  TestMac
//
//  Created by lian on 2022/1/8.
//

import Foundation
import CryptoKit
import CommonCrypto

class HLFileInfo {
    
    /// 文件地址
    let url: URL
    
    /// 文件名
    let filename: String
    
    /// 文件数据
    lazy var data: Data? = {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }()
    
    /// 文件大小
    let fileSize: Int
    
    /// 每个切片的data 值
    var offset: Int
    
    /// 文件的
    var mimeType: String? {
        return url.mimeType
    }
    
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
    
    /// 将文件切片
    /// - Returns: 切片
    func getFileSlice() throws -> [HLFileInfoSlice] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw HLFileInfoSlice.SliceError.flileNotExist
        }
        do {
            let fileData = try Data(contentsOf: url)
            let fileSize = fileData.count
            let trunkCount = Int(ceil(Double(fileSize) / Double(offset)))
            var ptr = 0
            var slices: [HLFileInfoSlice] = []
            for i in 0 ..< trunkCount {
                var range = ptr ..< fileSize
                if i == trunkCount - 1 {
                    range = ptr ..< fileSize
                }
                let data = fileData.subdata(in: range)
                slices.append(HLFileInfoSlice.init(data: data, range: range))
                ptr += offset;
            }
            return slices
        } catch {
            throw error
        }
    }
}

class HLFileInfoSlice {
    
    enum SliceError: LocalizedError {
        case flileNotExist
        var errorDescription: String? {
            switch self {
            case .flileNotExist:
                return "文件不存在了"
            }
        }
    }
    
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
