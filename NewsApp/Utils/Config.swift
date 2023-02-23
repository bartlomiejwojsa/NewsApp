//
//  Constants.swift
//  NewsApp
//
//  Created by Mohammad Azam on 6/30/21.
//

import Foundation

struct Config {
    static func getApiKey() -> String {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") else {
            return String()
        }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil
        ) as? [String: String] else {
            return String()
        }
        var result = String()
        for (key, value) in plist {
            if key == "ApiKey" {
                result = value
            }
        }
        return result
    }
}
