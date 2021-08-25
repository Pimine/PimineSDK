//
//  PMFirebaseUtilities.swift
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
import PimineUtilities
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class PMFirebaseUtilities {
    
    public typealias Parameters = [String: Any]
    
    // MARK: Private methods
    
    private static func _fetchReferences(
        in data: Parameters,
        for keys: [String],
        map mappedKeys: [String: String] = [:],
        recursive: Bool = true,
        on rootQueue: DispatchQueue = .global(qos: .userInteractive),
        result: @escaping (Result<Parameters, Error>) -> Void
    ) {
        dispatchPrecondition(condition: .onQueue(rootQueue))
        
        let dispatchGroup = DispatchGroup()
        var resolvedData = data
        var resolveError: Error?
        
        for key in keys {
            let value = data[key]
            let key = mappedKeys[key] ?? key
            let lowerLayerMappedKeys: [String: String] = Dictionary(
                uniqueKeysWithValues: mappedKeys.compactMap { (k, v) in
                    let keySegments = k.split(separator: ".")
                    return (keySegments[0] == key && keySegments.count > 1) ?
                        (keySegments.dropFirst().joined(separator: "."), v) :
                        nil
                }
            )
            
            switch value {
            case let reference as DocumentReference:
                dispatchGroup.enter()
                reference.getDocument { document, error in
                    rootQueue.async {
                        guard
                            let document = document,
                            let data = document.data(),
                            error.isNil
                        else {
                            let error = error ?? PMGeneralError(message: PMessages.somethingWentWrong)
                            resolveError = error
                            dispatchGroup.leave()
                            return
                        }
                        guard recursive else {
                            resolvedData[key] = data
                            dispatchGroup.leave()
                            return
                        }
                        _fetchReferences(in: data, map: lowerLayerMappedKeys, on: rootQueue) { result in
                            switch result {
                            case .success(let data):
                                resolvedData[key] = data
                            case .failure(let error):
                                resolveError = error
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            case let documentReferences as [DocumentReference]:
                dispatchGroup.enter()
                
                let localDispatchGroup = DispatchGroup()
                var localResult: [Int: [String: Any]] = [:]

                for (index, documentReference) in documentReferences.enumerated() {
                    localDispatchGroup.enter()
                    documentReference.getDocument { document, error in
                        rootQueue.async {
                            guard
                                let document = document,
                                let data = document.data(),
                                error.isNil
                            else {
                                let error = error ?? PMGeneralError(message: PMessages.somethingWentWrong)
                                resolveError = error
                                localDispatchGroup.leave()
                                return
                            }
                            guard recursive else {
                                localResult[index] = data
                                localDispatchGroup.leave()
                                return
                            }
                            _fetchReferences(in: data, map: lowerLayerMappedKeys, on: rootQueue) { result in
                                switch result {
                                case .success(let data):
                                    localResult[index] = data
                                case .failure(let error):
                                    resolveError = error
                                }
                                localDispatchGroup.leave()
                            }
                        }
                    }
                }
                localDispatchGroup.notify(queue: rootQueue) {
                    resolvedData[key] = documentReferences.enumerated().compactMap { localResult[$0.offset] }
                    dispatchGroup.leave()
                }
            case let parameters as Parameters:
                dispatchGroup.enter()
                
                _fetchReferences(in: parameters, map: lowerLayerMappedKeys, on: rootQueue) { result in
                    switch result {
                    case .success(let data):
                        resolvedData[key] = data
                    case .failure(let error):
                        resolveError = error
                    }
                    dispatchGroup.leave()
                }
            case let parameters as [Parameters]:
                dispatchGroup.enter()

                let localDispatchGroup = DispatchGroup()
                var localResult: [Int: Parameters] = [:]

                for (index, parameters) in parameters.enumerated() {
                    localDispatchGroup.enter()
                    _fetchReferences(in: parameters, map: lowerLayerMappedKeys, on: rootQueue) { result in
                        switch result {
                        case .success(let data):
                            localResult[index] = data
                        case .failure(let error):
                            resolveError = error
                        }
                        localDispatchGroup.leave()
                    }
                }

                localDispatchGroup.notify(queue: rootQueue) {
                    resolvedData[key] = parameters.enumerated().compactMap { localResult[$0.offset] }
                    dispatchGroup.leave()
                }
            default:
                continue
            }
        }
        dispatchGroup.notify(queue: rootQueue) {
            resolveError.isNil ? result(.success(resolvedData)) : result(.failure(resolveError!))
        }
    }
    
    private static func _fetchReferences(
        in data: [String: Any],
        exclude excludedKeys: [String] = [],
        map mappedKeys: [String: String] = [:],
        recursive: Bool = true,
        on rootQueue: DispatchQueue,
        result: @escaping (Swift.Result<[String: Any], Error>) -> Void
    ) {
        let keys = Array(data.keys).filter { !excludedKeys.contains($0) }
        _fetchReferences(
            in: data,
            for: keys,
            map: mappedKeys,
            recursive: recursive,
            on: rootQueue,
            result: result
        )
    }
    
    
    // MARK: Public methods
    
    public static func fetchReferences(
        in data: [String: Any],
        exclude excludedKeys: [String] = [],
        map mappedKeys: [String: String] = [:],
        recursive: Bool = true,
        on rootQueue: DispatchQueue = DispatchQueue(label: "com.pimine.Firebase.rootQueue"),
        result: @escaping (Swift.Result<[String: Any], Error>) -> Void
    ) {
        rootQueue.async {
            _fetchReferences(
                in: data,
                exclude: excludedKeys,
                map: mappedKeys,
                recursive: recursive,
                on: rootQueue,
                result: result
            )
        }
    }
    
    public static func data<T: Decodable>(as type: T.Type, from data: Parameters) throws -> T {
        let decoder = FirebaseFirestore.Firestore.Decoder()
        return try decoder.decode(type, from: data)
    }
}
