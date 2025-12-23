//
// Logger.swift
// MiniReduxDemo
// Created on 2025-12-22, 2025. 
//  

import Foundation

public protocol Logger: Sendable {
    /// Log a new message to the logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The level of the log
    ///   - category: The category of the log
    ///   - extra: Optional extras to send, in a dictionary format
    ///   - description: Optional description to add to the message
    ///   - file: The file this log is located in
    ///   - function: The function this log is located in
    ///   - line: The line number this log is located in
    func log(_ message: String,
             level: LoggerLevel,
             category: LoggerCategory,
             extra: [String: String]?,
             description: String?,
             file: String,
             function: String,
             line: Int)
}

public extension Logger {
    func log(_ message: String,
             level: LoggerLevel,
             category: LoggerCategory,
             extra: [String: String]? = nil,
             description: String? = nil,
             file: String = #filePath,
             function: String = #function,
             line: Int = #line) {
        self.log(message,
                 level: level,
                 category: category,
                 extra: extra,
                 description: description,
                 file: file,
                 function: function,
                 line: line)
    }
}
