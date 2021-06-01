//
//  DocumentReferenceExtensions.swift
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

import PimineUtilities
import FirebaseFirestore

public extension DocumentReference {
    
    func getDocument(includingReferences: Bool, recursive: Bool = true, result: @escaping (Result<[String: Any], Error>) -> Void) {
        getDocument { document, error in
            guard let document = document, let data = document.data(), error.isNil else {
                let error = error ?? PMGeneralError(message: PMessages.somethingWentWrong)
                return result(.failure(error))
            }
            includingReferences ?
                PMFirebaseUtilities.fetchReferences(in: data, recursive: recursive, result: result) :
                result(.success(data))
        }
    }
    
    func getDocument<T: Decodable>(
        as type: T.Type,
        includingReferences: Bool,
        recursive: Bool = true,
        result: @escaping (Result<T, Error>) -> Void
    ) {
        getDocument(includingReferences: includingReferences, recursive: recursive) { getResult in
            switch getResult {
            case .success(let data):
                guard let data = try? PMFirebaseUtilities.data(as: type, from: data) else {
                    let error = PMGeneralError(message: "Failed to decode \(type) from fetched data.")
                    return result(.failure(error))
                }
                return result(.success(data))
            case .failure(let error):
                return result(.failure(error))
            }
        }
    }
}
