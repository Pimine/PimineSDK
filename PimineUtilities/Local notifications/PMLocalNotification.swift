//
//  PMLocalNotification.swift
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

public struct PMLocalNotification: Codable {
    
    public struct Time: Codable {
        public let hour: Int
        public let minutes: Int
        public let seconds: Int
        public let weekday: Int
        
        public init(hour: Int, minutes: Int, seconds: Int, weekday: Int) {
            self.hour = hour
            self.minutes = minutes
            self.seconds = seconds
            self.weekday = weekday
        }
    }
    
    // MARK: Properties
    
    public let title: String
    public let body: String
    public let time: Time
    public let userInfo: [String: String]
    
    // MARK: Initialization
    
    public init(title: String, body: String, time: Time, userInfo: [String: String]) {
        self.title = title
        self.body = body
        self.time = time
        self.userInfo = userInfo
    }
}

public struct PMLocalNotificationSchedule: Codable {
    
    // MARK: Properties
    
    public let notifications: [PMLocalNotification]
    
    // MARK: Initialization
    
    public init(notifications: [PMLocalNotification]) {
        self.notifications = notifications
    }
}
