//
//  NotificationHandler.swift
//  https://github.com/Pimine/Pimine
//
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2021 Pimine
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

public struct NotificationHandler {
    
    // MARK: Properties
    
    private let rules: [String: [NotificationRule]]
    
    // MARK: Initialization
    
    public init(rules: [NotificationRule]) {
        self.rules = Dictionary(grouping: rules) { $0.type }
    }
    
    // MARK: Methods
    
    public func handle(_ userInfo: [AnyHashable: Any], result: @escaping (Result<Void, Error>) -> Void) {
        guard
            let type = userInfo["type"] as? String,
            let rules = rules[type]
        else {
            return result(.failure(.noRules))
        }
        
        for rule in rules {
            guard let output = try? rule.evaluate(userInfo) else { continue }
            
            output.execute { sink in
                switch sink {
                case .success:
                    return result(.success(()))
                case .failure(let error):
                    return result(.failure(.executionError(error)))
                }
            }
            return
        }
        return result(.failure(.noEvaluatedRules))
    }
}

// MARK: - Error

public extension NotificationHandler {
    
    enum Error: Swift.Error {
        case noRules
        case executionError(Swift.Error)
        case noEvaluatedRules
    }
}
