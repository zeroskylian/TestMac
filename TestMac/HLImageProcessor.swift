//
//  HLImageProcessor.swift
//  HengLink_Mac
//
//  Created by lian on 2021/7/5.
//

import Kingfisher
import func AVFoundation.AVMakeRect

struct HLImageProcessor: ImageProcessor {
    var identifier: String = "HLImageProcessor"
    
    var processSize: CGSize
    
    static let avatar = HLImageProcessor(processSize: CGSize(width: 40, height: 40))
    
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .data(let data):
            if let image = NSImage(data: data) {
                let new = image.resizeAvatar(processSize)
                return new
            }
            return nil
        case .image(let image):
            let new = image.resizeAvatar(processSize)
            return new
        }
    }
}

extension CGSize {
    func getMaxSize(by maxSize: CGSize) -> CGSize {
        if width <= maxSize.width && height <= maxSize.height {
            return self
        }
        let rect = AVMakeRect(aspectRatio: self, insideRect: CGRect(origin: .zero, size: maxSize))
        return rect.size
    }
}
