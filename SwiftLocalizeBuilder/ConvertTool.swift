//
//  ConvertTool.swift
//  SwiftLocalizeBuilder
//
//  Created by liuming on 2018/9/10.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import Cocoa

public class ConvertTool: NSObject {
    private var inputFile:String?
    private var outputPath:String?
    
    public override init() {
        super.init()
    }
    public func setInputFile(_ file:String){
        self.inputFile = file
    }
    public func setOutputPath(_ path:String){
        self.outputPath = path
    }
    
    public func start() throws -> Bool {
    
        guard let iFile = self.inputFile else {
            throw ConvertError.inputFileNil
        }
        guard let oPath = self.outputPath else {
            throw ConvertError.outputPathNil
        }
        let x = LineReader(path: iFile)
        guard let reader = x else {
            throw NSError(domain: "FileNotFound", code: 404, userInfo: nil)
        }
        var isNote = false
        var codeStr = "extension String {\n"
        for line in reader {
            if line == "\n"{continue}
            if line.hasPrefix("//") {continue}
            if line.hasSuffix("*/\n") {isNote = false;continue}
            if isNote || line.hasPrefix("/*") {isNote = true;continue}
            
            let str1 = line.replacingOccurrences(of: ";", with: "")
                .replacingOccurrences(of: " ", with: "");
            let splitArray:[Substring] = str1.split(separator: "=")
            let key = String.init(splitArray.first!)
            let value = String.init(splitArray.last!)
            codeStr += self.buildCode(key, value: value)
            print(line)
        }
        codeStr.append("\n\tpublic var localized: String { return NSLocalizedString(self, comment: \"\")}")
        
        codeStr.append("\n }")
        let data = codeStr.data(using: .utf8)
        
        do {
            try data?.write(to: URL.init(fileURLWithPath: oPath + "/test.swift"), options: Data.WritingOptions.atomic)
            NSWorkspace.shared.open(URL.init(fileURLWithPath: oPath, isDirectory: true))
        } catch let error {
            print("文件写入失败 error = \(error)")
        }
        return true
    }
    
    public func buildCode(_ key:String,value:String) ->String {
        
        let newKey = key.replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "\n", with: "")
            .lowercased()
        
        let newValue = value.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\n", with: "")
        let valueKey  = key.replacingOccurrences(of: " ", with: "")
        var codeStr = "\t/// " + newValue + "\n"
        codeStr += "\tpublic var  \(newKey):String = { return \(valueKey).localized" + " }\n"
        return codeStr
    }
}
