//
//  PMCoordinator.swift
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

import UIKit

open class PMCoordinator: NSObject {
    
    // MARK: Properties
    
    public let rootViewController: UINavigationController

    private(set) var childCoordinators: [PMCoordinator] = []
    
    // MARK: Initialization
    
    public init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    // MARK: Flow

    public func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    public func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    // MARK: Dependancies

    public func addChildCoordinator(_ coordinator: PMCoordinator) {
        childCoordinators.append(coordinator)
    }

    public func removeChildCoordinator(_ coordinator: PMCoordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }

    public func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }

    public func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

// MARK: - Equatable

public extension PMCoordinator {
    
    static func == (lhs: PMCoordinator, rhs: PMCoordinator) -> Bool {
        return lhs === rhs
    }
    
}
