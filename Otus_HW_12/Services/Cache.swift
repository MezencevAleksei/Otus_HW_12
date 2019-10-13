//
//  Cache.swift
//  Otus_HW_12
//
//  Created by alex on 13.10.2019.
//  Copyright © 2019 Mezencev Aleksei. All rights reserved.
//

import Foundation

class Cache {

    enum Directory {
        case documents
        case caches
    }


    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError("Cannot store file")
        }
    }

    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type, _ ifExist: Bool = true) -> T? {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)

        guard FileManager.default.fileExists(atPath: url.path) else {
            if !ifExist {
                fatalError("File doesn't exist")
            }else{
                return nil
            }
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)")
        }
    }


    static private func getURL(for directory: Directory) -> URL {
        var searchDirectory: FileManager.SearchPathDirectory

        switch directory {
        case .documents:
            searchDirectory = .documentDirectory
        case .caches:
            searchDirectory = .cachesDirectory
        }

        guard let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first else {
            fatalError("Could npot create documents folder")
        }
        return url
    }

}
