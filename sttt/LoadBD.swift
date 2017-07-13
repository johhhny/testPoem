//
//  LoadBD.swift
//  sttt
//
//  Created by user on 13.07.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import Foundation

class Load_BD {
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        //print(fileURL)
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        //print(fileManager.fileExists(atPath: dbPath))
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            //print(fromPath)
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            if (error != nil) {
                print("Error Occured")
                //print(error.localizedDescription)
            } else {
                print("Successfully Copy")
                print("Your database copy successfully")
            }
        }
        else
        {
            print("База данных есть!")
        }
    }
}
