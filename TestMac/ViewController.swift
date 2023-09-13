//
//  ViewController.swift
//  TestMac
//
//  Created by lian on 2021/7/2.
//

import Cocoa
import Combine
import Kingfisher
import SWXMLHash

class ViewController: NSViewController {
    
    var haveCSV: Bool = false
    
    var csvDict: [String: String] = [:]
    
    var haveString: Bool = false
    
    var stringDict: [StringModel] = []
    
    var mergerDict: [String: String] = [:]
    
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
            let data = try Data(contentsOf: url)
            guard let dataEncoded = String(data: data, encoding: .utf8) else { return }
            let xml = XMLHash.parse(dataEncoded)
            let strings: [StringModel] = try xml["resources"]["string"].value()
            self.stringDict = strings
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
        var save: [StringModel] = []
        for model in stringDict {
            if let value = csvDict[model.value] {
                mergerDict[model.value] = value
                model.value = value
                count += 1
                save.append(model)
                mergerDict[model.value] = value
            }
        }
        print(count)
        
        var strings = save.reduce("") { partialResult, model in
            return partialResult + model.toXML()
        }
        strings = "<resources>\(strings)</resources>"
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
    
    @IBAction func exportUnmerger(_ sender: Any) {
        var dict: [String: String] = [:]
        print(mergerDict.count)
        print(csvDict.count)
        var count: Int = 0
        csvDict.forEach({ (key, value) in
            if mergerDict[value] == nil {
                dict[key] = value
                count += 1
            }
        })
        print(count)
        var csvString = "\("Key"),\("Value")\n\n"
        for row in dict {
            let string = "\(String(describing: row.0)) ,\(String(describing: row.1))\n"
            csvString.append(string)
            csvString.append("\n")
        }
        
        let data = csvString.data(using: .utf8)
        let savePanel = NSSavePanel()
        savePanel.title = "保存"
        savePanel.message = "保存文件"
        savePanel.nameFieldStringValue = "unmerger.csv"
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

final class StringModel: CustomStringConvertible, XMLObjectDeserialization, Equatable {
    
    let key: String
    
    var value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    var description: String {
        return "key: \(key)\nvalue:\(value) \n ===="
    }
    
    func toXML() -> String {
        return "<string name=\"\(key)\">\(value)</string>"
    }
    
    static func deserialize(_ node: XMLIndexer) throws -> StringModel {
        return try StringModel(
            key: node.value(ofAttribute: "name"), value: node.value()
        )
    }
    
    static func == (lhs: StringModel, rhs: StringModel) -> Bool {
        return lhs.key == rhs.key
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
