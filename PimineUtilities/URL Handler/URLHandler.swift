//
//  URLHandler.swift
//  https://github.com/Pimine/PimineSDK
//
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2020 Pimine
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

public struct URLHandler {
    
    // MARK: - Properties
    
    private let scheme: String
    private let rules: [String : [URLRule]]

    // MARK: - Initialization
    
    public init(scheme: String, rules: [URLRule]) {
        self.scheme = scheme
        self.rules = Dictionary(grouping: rules) { $0.requiredHost }
    }
    
    // MARK: - Methods
    
    public func handle(_ url: URL, result: @escaping (Result<Void, Error>) -> Void) {
        guard url.scheme == scheme else {
            return result(.failure(.wrongScheme))
        }
        guard
            let host = url.host,
            let rules = rules[host]
        else {
            return result(.failure(.noRules))
        }

        let input = URLRule.Input(url: url)

        for rule in rules {
            if rule.requiresPathComponents {
                guard !input.pathComponents.isEmpty else { continue }
            }
            
            guard let output = try? rule.evaluate(input) else { continue }
            
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

// MARK: - URLHandler

public extension URLHandler {
    
    enum Error: Swift.Error {
        case wrongScheme
        case noRules
        case executionError(Swift.Error)
        case noEvaluatedRules
    }
}
