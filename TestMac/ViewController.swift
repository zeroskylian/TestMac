//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import Combine
import Kingfisher

class ViewController: NSViewController {
    
    var haveCSV: Bool = false
    
    var csvDict: [String: String] = [:]
    
    var haveString: Bool = false
    
    var stringDict: [StringModel] = []
    
    
    @IBOutlet weak var xlsName: NSTextField!
    
    @IBOutlet weak var stringsLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.title = "文件选择"
        openPanel.canChooseFiles = true
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.beginSheetModal(for: view.window!) { response in
            if response == .OK {
                guard let url = openPanel.url else { return }
                self.readCSV(url: url)
            }
        }
    }
    
    func readCSV(url: URL) {
        do {
            var dataArray = [[String]]()
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\r\n").map({ $0.components(separatedBy: ";") }) {
                for line in dataArr {
                    dataArray.append(line)
                }
            }
        
            var dict: [String: String] = [:]
            for value in dataArray {
                guard let first = value.first else { continue }
                print(first)
                let arr = first.components(separatedBy: ",")
                guard arr.count > 1 else { continue }
                let last = Array(arr.dropFirst())
                dict[arr[0]] = last.joined()
                
            }
            self.csvDict = dict
            self.haveCSV = true
            self.xlsName.stringValue = url.lastPathComponent
        } catch {
            print(error)
        }
    }
    
    @IBAction func readStringsAction(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.title = "strings选择"
        openPanel.canChooseFiles = true
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.beginSheetModal(for: view.window!) { response in
            if response == .OK {
                guard let url = openPanel.url else { return }
                self.readStrings(url: url)
            }
        }
        
    }
    
    func readStrings(url: URL) {
        do {
            var dataArray = [StringModel]()
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: ";") {
                var count: Int = 0
                for line in dataArr {
                    if let model = StringModel(string: line) {
                        print(model.key)
                        dataArray.append(model)
                        count += 1
                    }
                }
                print(count)
            }
            
            self.stringDict = dataArray
            self.haveString = true
            self.stringsLabel.stringValue = url.lastPathComponent
        } catch {
            print(error)
        }
    }
    
    @IBAction func mergerAction(_ sender: Any) {
        guard haveCSV, haveString else {
            print(haveCSV, haveString)
            return
        }
        var count: Int = 0
        for model in stringDict {
            if let value = csvDict[model.key] {
                model.value = "\"\(value)\""
                count += 1
            }
        }
        print(count)
        let strings = stringDict.reduce("") { partialResult, model in
            return partialResult + model.toStrings()
        }
        
        let data = strings.data(using: .utf8)
        let savePanel = NSSavePanel()
        savePanel.title = "保存"
        savePanel.message = "保存文件"
        savePanel.nameFieldStringValue = stringsLabel.stringValue
        savePanel.begin { response in
            guard let url = savePanel.url else { return }
            if response == .OK {
                do {
                    try data?.write(to: url)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

class StringModel: CustomStringConvertible {
    
    let remark: String?
    
    let key: String
    
    var value: String
    
    init(remark: String?, key: String, value: String) {
        self.remark = remark
        self.key = key
        self.value = value
    }
    
    init?(string: String) {
        let array = string.trimmed.components(separatedBy: "\n")
        guard array.count == 2 else { return nil }
        let content = array[1].deletingSuffix(";")
        let contentArray = content.components(separatedBy: " = ")
        guard contentArray.count == 2 else { return nil }
        self.remark = array.first
        self.key = contentArray[0].deletingPrefix("\"").deletingSuffix("\"")
        self.value = contentArray[1]
    }
    
    func toStrings() -> String {
        var string = ""
        if let remark {
            string.append(remark)
            string.append("\n")
        }
        string.append("\"\(key)\"")
        string.append(" = ")
        string.append("\(value)")
        string.append(";\n\n")
        return string
    }
    
    var description: String {
        return "reamrk: \(remark ?? "") \nkey: \(key)\nvalue:\(value) \n ===="
    }
}

extension String {
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
}
