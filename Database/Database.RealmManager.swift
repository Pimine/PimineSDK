//
//  Database.RealmManager.swift
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

import RealmSwift

public extension Database {
    
    static func save(_ object: Object, update: Realm.UpdatePolicy) {
        try? realm.write {
            realm.add(object, update: update)
        }
    }

    static func save(_ objects: [Object], update: Realm.UpdatePolicy) {
        try? realm.write {
            realm.add(objects, update: update)
        }
    }

    static func objects<Element: Object>(_ type: Element.Type) -> Array<Element> {
        Array(realm.objects(type))
    }

    @discardableResult
    static func hydrate<Element: Object>(_ incoming: Element, excluding excludedProperties: [String] = []) -> Bool {
        guard
            let key = Element.primaryKey(),
            let identifier = incoming[key],
            let stored = realm.object(ofType: Element.self, forPrimaryKey: identifier)
        else { return false }
        
        let blankReference = Element()
        incoming.objectSchema.properties
            .lazy
            .map { $0.name }
            .filter { !excludedProperties.contains($0) }
            .filter { incoming[$0] as AnyObject === blankReference[$0] as AnyObject }
            .forEach { incoming[$0] = stored[$0] }
        
        return true
    }
}
