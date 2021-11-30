//
//  DragViewController.swift
//  TestMac
//
//  Created by lian on 2021/11/16.
//

import AppKit

class DragViewController: NSViewController {
    
    override func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 550, height: 550))
    }
    
    /// Queue used for reading and writing file promises.
    private lazy var workQueue: OperationQueue = {
        let providerQueue = OperationQueue()
        providerQueue.qualityOfService = .userInitiated
        return providerQueue
    }()
    
    /// Directory URL used for accepting file promises.
    private lazy var destinationURL: URL = {
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Drops")
        try? FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        return destinationURL
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = NSImage(named: "tieba")!
        let imageView = TestImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let dragView = HLDragView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        dragView.layerBackgroundColor = .cyan
//        dragView.contents = imageView
        dragView.delegate = self
        view.addSubview(dragView)
        dragView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 200))
            make.left.equalToSuperview().offset(0)
            make.top.equalTo(100)
        }
    }
}

extension DragViewController: HLDragViewDelegate {
    func draggingOverlaySize() -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func draggingEntered(for dragView: HLDragView, sender: NSDraggingInfo) -> NSDragOperation {
        return sender.draggingSourceOperationMask.intersection([.copy])
    }
    
    func performDragOperation(for dragView: HLDragView, sender: NSDraggingInfo) -> Bool {
        let supportedClasses = [
            NSFilePromiseReceiver.self,
            NSURL.self
        ]

        let searchOptions: [NSPasteboard.ReadingOptionKey: Any] = [
            .urlReadingFileURLsOnly: true,
            .urlReadingContentsConformToTypes: [ kUTTypeImage ]
        ]
        
        /// - Tag: HandleFilePromises
        sender.enumerateDraggingItems(options: [], for: nil, classes: supportedClasses, searchOptions: searchOptions) { (draggingItem, _, _) in
            switch draggingItem.item {
            case let filePromiseReceiver as NSFilePromiseReceiver:
                filePromiseReceiver.receivePromisedFiles(atDestination: self.destinationURL, options: [:], operationQueue: self.workQueue) { (fileURL, error) in
                    if let error = error {
                        print(error)
                    } else {
                        print(fileURL)
                    }
                }
            case let fileURL as URL:
                print(fileURL)
            default: break
            }
        }
        return true
    }
    
    func pasteboardWriter(for dragView: HLDragView) -> NSPasteboardWriting {
        let provider = NSFilePromiseProvider(fileType: kUTTypeJPEG as String, delegate: self)
        provider.userInfo = dragView.snapshotItem
        return provider
    }
}

// MARK: - NSFilePromiseProviderDelegate
extension DragViewController: NSFilePromiseProviderDelegate {
    /// - Tag: ProvideFileName
    func filePromiseProvider(_ filePromiseProvider: NSFilePromiseProvider, fileNameForType fileType: String) -> String {
        if let snapshot = filePromiseProvider.userInfo as? HLDragView.SnapshotItem {
            return snapshot.name
        }
        let droppedFileName = NSLocalizedString("DropFileTitle", comment: "")
        return droppedFileName + ".jpg"
    }
    
    /// - Tag: ProvideOperationQueue
    func operationQueue(for filePromiseProvider: NSFilePromiseProvider) -> OperationQueue {
        return workQueue
    }
    
    /// - Tag: PerformFileWriting
    func filePromiseProvider(_ filePromiseProvider: NSFilePromiseProvider, writePromiseTo url: URL, completionHandler: @escaping (Error?) -> Void) {
        do {
            if let snapshot = filePromiseProvider.userInfo as? HLDragView.SnapshotItem {
                switch snapshot {
                case .image(name: _, image: let image):
                    if let tiffData = image.tiffRepresentation {
                        try tiffData.write(to: url)
                    }
                case .data(name: _, data: let data):
                    try data.write(to: url)
                case .file(name: _, url: let fileURL):
                    try FileManager.default.copyItem(at: fileURL, to: url)
                }
            } else {
                throw RuntimeError.unavailableSnapshot
            }
            completionHandler(nil)
        } catch let error {
            completionHandler(error)
        }
    }
}

enum RuntimeError: Error {
    case unavailableSnapshot
}

class TestImageView: NSImageView, HLDragViewContent {
    var snapshotItem: HLDragView.SnapshotItem? = .image(name: "test.png", image: NSImage(named: "tieba")!)
}
