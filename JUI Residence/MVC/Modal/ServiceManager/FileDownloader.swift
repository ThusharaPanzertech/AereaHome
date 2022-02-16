//
//  FileDownloader.swift
//  lumiere
//
//  Created by Panzer Tech on 18/10/19.
//  Copyright © 2019 PanzerTech. All rights reserved.
//

import Foundation
class  FileDownloader{
    
    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }
    
    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
    
    static func getDownloadedFile(requestURL: String) -> String
    {
        if(requestURL.count == 0){
          return ""
        }
        
        let url:URL = URL(string: requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
    
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            return destinationUrl.path
        }
    // return requestURL
       return ""
    }
    
    static func downloadFiles(files: [String])
    {
        
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        
        for item in files{
            let url:URL = URL(string: item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
            
            if FileManager().fileExists(atPath: destinationUrl.path)
            {
                
            }
            else
            {
               
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let task = session.dataTask(with: request, completionHandler:
                {
                    data, response, error in
                   // print(error)
                    if error == nil
                    {
                        if let response = response as? HTTPURLResponse
                        {
                            if response.statusCode == 200 || response.statusCode == 403
                            {
                                if let data = data
                                {
                                    let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                }
                            }
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    static func clearAllFile() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try fileManager.removeItem(at: myDocuments)
        } catch {
            return
        }
    }
}
