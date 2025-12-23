// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

public struct DefaultLogger: Logger {
    public static let shared = DefaultLogger()

    init() {}

    public func log(_ message: String,
                    level: LoggerLevel,
                    category: LoggerCategory,
                    extra: [String: String]? = nil,
                    description: String? = nil,
                    file: String = #filePath,
                    function: String = #function,
                    line: Int = #line) {
        // Prepare messages
        let reducedExtra = reduce(extraEvents: extra)
        var loggerMessage = "\(message)"
        let prefix = " - "
        if let description = description {
            loggerMessage.append("\(prefix)\(description)")
        }

        if !reducedExtra.isEmpty {
            loggerMessage.append("\(prefix)\(reducedExtra)")
        }

        // Log locally and in console
        print("LOG 🪵 \(loggerMessage)")
    }

    // MARK: - Private

    private func reduce(extraEvents: [String: String]?) -> String {
        guard let extras = extraEvents else { return "" }

        return extras.reduce("") { (result: String, arg1) in
            let (key, value) = arg1
            let pastResult = result.isEmpty ? "" : "\(result), "
            return "\(pastResult)\(key): \(value)"
        }
    }
}
