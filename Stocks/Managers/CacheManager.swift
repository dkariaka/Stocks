//
//  CacheManager.swift
//  Stocks
//
//  Created by Дмитрий К on 07.07.2025.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = path[0].appendingPathComponent("CustomCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path()) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func save<T: Encodable>(_ object: T, to fileName: String) {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save cache: \(error)")
        }
    }
    
    func load<T: Decodable>(_ type: T.Type, from fileName: String) -> T? {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Failed to load cache: \(error)")
            return nil
        }
    }
    
    func isCacheValid(for fileName: String, maxAgeMinutes: Int) -> Bool {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        guard let attrs = try? fileManager.attributesOfItem(atPath: fileURL.path()), let modificationDate = attrs[.modificationDate] as? Date else {
            return false
        }
        
        let age = Date().timeIntervalSince(modificationDate)
        return age < Double(maxAgeMinutes * 60)
    }
    
    func removeCache(for fileName: String) {
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        try? fileManager.removeItem(at: fileURL)
    }
}
