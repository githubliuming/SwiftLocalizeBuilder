//
//  ViewController.swift
//  SwiftLocalizeBuilder
//
//  Created by liuming on 2018/9/10.
//  Copyright © 2018年 yoyo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    @IBOutlet weak var inputPath: NSTextField!
    
    @IBOutlet weak var outputPath: NSTextField!
    
    private let tool:ConvertTool = ConvertTool.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func inputBtnClickHandler(_ sender: NSButton) {
        
        let panel :NSOpenPanel  = NSOpenPanel.init()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        let finded = panel.runModal()
        if  finded == NSApplication.ModalResponse.OK{
            panel.urls.forEach { (url) in
                print("选择文件的路径 ----- \(url.path)")
                inputPath.stringValue = url.path
            }
        }
    }
    
    @IBAction func outPutBtnClickHandler(_ sender: NSButton) {
        
        let panel :NSOpenPanel  = NSOpenPanel.init()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        let finded = panel.runModal()
        if  finded == NSApplication.ModalResponse.OK{
            panel.urls.forEach { (url) in
                print("选择文件的路径 ----- \(url.path)")
                outputPath.stringValue = url.path
            }
        }
    }
    
    @IBAction func startTurn(_ sender: Any) {
        
        // 转换开始
        if  !inputPath.stringValue.isEmpty &&
            !outputPath.stringValue.isEmpty {
            print(inputPath.stringValue + "       " + outputPath.stringValue)
            
            tool.setInputFile(inputPath.stringValue)
            tool.setOutputPath(outputPath.stringValue)
            do {
             
              let _ = try tool.start()
            } catch let _{
                
//                print(\(error))
            }
        } else {
    
            let alert = NSAlert.init()
            alert.alertStyle = .warning
            alert.messageText = "输入文件或者输出路径至少有一个为空！！！"
            alert.runModal()
        }
    }
    
}

