//
//  NSImageExtensions.swift
//  SwifterSwift-macOS
//
//  Created by BUDDAx2 on 20.10.2017.
//  Copyright © 2017 SwifterSwift
//

#if os(macOS)
import AppKit

// MARK: - Methods
extension NSImage {
	
	/// SwifterSwift: NSImage scaled to maximum size with respect to aspect ratio
	///
	/// - Parameter toMaxSize: maximum size
	/// - Returns: scaled NSImage
	func scaled(toMaxSize: NSSize) -> NSImage {
		var ratio: Float = 0.0
		let imageWidth = Float(self.size.width)
		let imageHeight = Float(self.size.height)
		let maxWidth = Float(toMaxSize.width)
		let maxHeight = Float(toMaxSize.height)
		
		// Get ratio (landscape or portrait)
		if imageWidth > imageHeight {
			// Landscape
			ratio = maxWidth / imageWidth
		} else {
			// Portrait
			ratio = maxHeight / imageHeight
		}
		
		// Calculate new size based on the ratio
		let newWidth = imageWidth * ratio
		let newHeight = imageHeight * ratio
		
		// Create a new NSSize object with the newly calculated size
		let newSize: NSSize = NSSize(width: Int(newWidth), height: Int(newHeight))
		
		// Cast the NSImage to a CGImage
		var imageRect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
		let imageRef = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
		
		// Create NSImage from the CGImage using the new size
		let imageWithNewSize = NSImage(cgImage: imageRef!, size: newSize)
		
		// Return the new image
		return imageWithNewSize
	}
	
	/// SwifterSwift: Write NSImage to url.
	///
	/// - Parameters:
	///   - url: Desired file URL.
	///   - type: Type of image (default is .jpeg).
	///   - compressionFactor: used only for JPEG files. The value is a float between 0.0 and 1.0, with 1.0 resulting in no compression and 0.0 resulting in the maximum compression possible.
	func write(to url: URL, fileType type: NSBitmapImageRep.FileType = .jpeg, compressionFactor: NSNumber = 1.0) {
		// https://stackoverflow.com/a/45042611/3882644
		
		guard let data = tiffRepresentation else { return }
		guard let imageRep = NSBitmapImageRep(data: data) else { return }
		
		guard let imageData = imageRep.representation(using: type, properties: [.compressionFactor: compressionFactor]) else { return }
		try? imageData.write(to: url)
	}
    
    func getMaxSize(by maxHeight: CGFloat) -> CGSize {
        return size.getMaxSize(by: CGSize(width: maxHeight, height: maxHeight))
    }
    
    public func resizeImage(_ size: NSSize) -> NSImage {
        let targetFrame = NSRect(origin: CGPoint(x: 0, y: 0), size: size)
        let targetImage = NSImage(size: size)
        let selfSize = self.size
        let ratioHeight = size.height / selfSize.height
        let ratioWidth = size.width / selfSize.width
        var cropRect: NSRect = .zero
        if ratioHeight >= ratioWidth {
            cropRect.size.width = floor(size.width / ratioHeight)
            cropRect.size.height = selfSize.height
        } else {
            cropRect.size.width = selfSize.width
            cropRect.size.height = floor(size.height / ratioWidth)
        }

        cropRect.origin.x = floor((selfSize.width - cropRect.size.width) / 2)
        cropRect.origin.y = floor((selfSize.height - cropRect.size.height) / 2)

        targetImage.lockFocus()
        self.draw(in: targetFrame, from: cropRect, operation: .copy, fraction: 1.0, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.low.rawValue])
        targetImage.unlockFocus()
        return targetImage
    }
	
    public func resizeAvatar(_ size: NSSize) -> NSImage? {
        let targetFrame = NSRect(origin: CGPoint(x: 0, y: 0), size: size)
        let targetImage = NSImage(size: size)
        let selfSize = self.size
        let ratioHeight = size.height / selfSize.height
        let ratioWidth = size.width / selfSize.width
        var cropRect: NSRect = .zero
        if ratioHeight >= ratioWidth {
            cropRect.size.width = floor(size.width / ratioHeight)
            cropRect.size.height = selfSize.height
        } else {
            cropRect.size.width = selfSize.width
            cropRect.size.height = floor(size.height / ratioWidth)
        }

        cropRect.origin.x = floor((selfSize.width - cropRect.size.width) / 2)
        cropRect.origin.y = floor((selfSize.height - cropRect.size.height) / 2)

        targetImage.lockFocus()
        self.draw(in: targetFrame, from: cropRect, operation: .copy, fraction: 1.0, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.low.rawValue])
        targetImage.unlockFocus()
        return targetImage
    }
}
#endif
