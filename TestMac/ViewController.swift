//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import SnapKit
import WebKit
import Alamofire

class ViewController: NSViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "http://10.11.83.3")!))
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func delay(seconds: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
    }
}

// MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        let urlString = url.absoluteString
        if url.pathExtension.count > 0, (!urlString.hasSuffix("html") || urlString.hasSuffix("htm")) {
            let savePanel = NSSavePanel.init()
            savePanel.title = "保存"
            savePanel.message = "保存文件"
            savePanel.nameFieldStringValue = url.lastPathComponent
            savePanel.begin { response in
                guard let url = savePanel.url else { return }
                if response == .OK {
                    Session.default.download(urlString, to: { temporaryURL, response in
                        let fileName = url.lastPathComponent
                        return (url, [.removePreviousFile])
                    }).downloadProgress { progressValue in
                        
                    }.responseData { response in
                        
                    }
                }
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

// MARK: - WKUIDelegate
extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.title = "文件选择"
        openPanel.canChooseFiles = true
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.beginSheetModal(for: view.window!) { response in
            if response == .OK {
                guard let url = openPanel.url else { return }
                completionHandler([url])
            }
        }
    }
}
