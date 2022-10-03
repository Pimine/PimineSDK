//
//  PMFirestoreDocument.swift
//  https://github.com/denandreychuk/Pimine
//
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2021 PimineSDK
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

import FirebaseFirestore

public struct PMFirestoreDocument<T: Codable & Hashable>: Codable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case reference
        case document
    }

    // MARK: Properties
    
    private var reference: DocumentReference?
    private(set) public var document: T?
    
    // MARK: Initialization
    
    public init(document: T) {
        self.document = document
    }
    
    public init(reference: DocumentReference) {
        self.reference = reference
    }

    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        if let reference = try? singleValueContainer.decode(DocumentReference.self) {
            self.reference = reference
        } else {
            self.document = try singleValueContainer.decode(T.self)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let document = document {
            try container.encode(document)
        } else {
            try container.encode(reference)
        }
    }
}

