//
// PrettyPrint.swift
// MiniReduxDemo
// Created on 2025-12-22, 2025. 
//  

import Foundation

func prettyPrint(withPrefix prefix: String? = nil, _ object: Codable) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let jsonData = try encoder.encode(object)

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            if let prefix {
                print("\(prefix): \(jsonString)")
            } else {
                print(jsonString)
            }
        }
    } catch {
        print("Error encoding object for prettyPrint: \(error)")
    }
}
