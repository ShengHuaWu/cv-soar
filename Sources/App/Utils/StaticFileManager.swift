//
//  UserController.swift
//  App
//
//  Created by ShengHua Wu on 11/11/2017.
//

import Foundation

final class StaticFileManager {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func fileExist(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return false
        }
        
        return isDirectory.boolValue
    }
    
    func removeFile(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    func save(bytes: Bytes, to url: URL, with byteHandler: (Bytes) -> Data = Data.init) throws {
        let data = byteHandler(bytes)
        try data.write(to: url)
    }
}
