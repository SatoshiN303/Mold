//
//  main.swift
//  Bootstrap
//
//  Created by 佐藤 慎 on 2020/05/26.
//  Copyright © 2020 STSN. All rights reserved.
//
// シンボリックリンクする

import Foundation

let destUrl = "/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/Project Templates/iOS/Application/"
let templateDir = "Mold"

func copyTemplate(){
    let fileManager = FileManager.default
    let destinationPath = bash(command: "xcode-select", arguments: ["--print-path"]).appending(destUrl) + templateDir
    
    do {
        // You must run "/bootstrap.swift" in the terminal to find the "Mold" directory.
        if !fileManager.fileExists(atPath: destinationPath) {
            try fileManager.copyItem(atPath: templateDir, toPath: destinationPath)
            print("\n")
            print("Successfully installed the VIPER template🍻 \n")
            print("You can use it from [Xcode Menu -> File -> New -> File -> iOS -> Mold]")
        } else {
            try fileManager.removeItem(atPath: destinationPath)
            try fileManager.copyItem(atPath: templateDir, toPath: destinationPath)
            print("\n")
            print("Viper template updated!!🍻")
        }
    }
    catch let error as NSError {
        print("Error: \(error.localizedFailureReason!)")
    }
}

@discardableResult
func shell(launchPath: String, arguments: [String]) -> String
{
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    guard let output = String(data: data, encoding: String.Encoding.utf8) else {
        fatalError()
    }
    
    if output.count > 0 {
        let lastIndex = output.index(before: output.endIndex)
        return String(output[output.startIndex ..< lastIndex])
    }

    return output
}

func bash(command: String, arguments: [String]) -> String {
    let command = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
    return shell(launchPath: command, arguments: arguments)
}

copyTemplate()


