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
        var codeStr = "extension String {"
        for line in reader {
            
            if line.hasPrefix("//") {continue}
            if line.hasSuffix("*/\n") {isNote = false;continue}
            if isNote || line.hasPrefix("/*") {isNote = true;continue}
            let str1 = line.replacingOccurrences(of: ";", with: "");
            let splitArray:[Substring] = str1.split(separator: "=")
            let key = String.init(splitArray.first!)
            let value = String.init(splitArray.last!)
            codeStr += self.buildCode(key, value: value)
            print(line)
        }
        codeStr.append("\n  var localized: String { return NSLocalizedString(self, comment: \"\")}")
        
        codeStr.append("\n }")
        let data = codeStr.data(using: .utf8)
        FileManager.default.createFile(atPath: oPath + "text.txt", contents: data, attributes: nil)
        return true
    }
    
    public func buildCode(_ key:String,value:String) ->String {
        
        let newKey = key.replacingOccurrences(of: "\"", with: "").uppercased()
        let newValue = value.replacingOccurrences(of: "\"", with: "")
        var codeStr = "/// " + newValue + "\n"
        codeStr += "public static let \(newKey) = \"\(newValue)\".localized" + "\n"
        return codeStr
    }
}
