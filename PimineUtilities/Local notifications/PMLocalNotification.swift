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
import NotificationCenter

public struct PMLocalNotificationContent: Codable {
    
    // MARK: Properties
    
    public let title: String
    public let body: String
    public let userInfo: [String: String]
    
    // MARK: Initialization
    
    public init(title: String, body: String, userInfo: [String: String]) {
        self.title = title
        self.body = body
        self.userInfo = userInfo
    }
}

public protocol PMLocalNotificationTrigger: Decodable {
    var repeats: Bool { get }
    var notificationTrigger: UNNotificationTrigger { get }
}

public struct PMLocalNotificationCalendarTrigger: PMLocalNotificationTrigger {
    public let dateComponents: DateComponents
    public let repeats: Bool
    
    public var notificationTrigger: UNNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
    }
    
    public init(dateComponents: DateComponents, repeats: Bool) {
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
}

public struct PMLocalNotificationTimeIntervalTrigger: PMLocalNotificationTrigger {
    public let timeInterval: TimeInterval
    public let repeats: Bool
    
    public var notificationTrigger: UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    }
    
    public init(timeInterval: TimeInterval, repeats: Bool) {
        self.timeInterval = timeInterval
        self.repeats = repeats
    }
}

public struct PMLocalNotification: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case type
        case content
        case trigger
    }
    
    enum NotificationType: String, Decodable {
        case timeInterval
        case calendar
    }

    // MARK: Properties
    
    public let content: PMLocalNotificationContent
    public let trigger: PMLocalNotificationTrigger
    
    // MARK: Initialization
    
    public init(content: PMLocalNotificationContent, trigger: PMLocalNotificationTrigger) {
        self.content = content
        self.trigger = trigger
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(NotificationType.self, forKey: .type)
        self.content = try container.decode(PMLocalNotificationContent.self, forKey: .content)
        
        switch type {
        case .calendar:
            self.trigger = try container.decode(PMLocalNotificationCalendarTrigger.self, forKey: .trigger)
        case .timeInterval:
            self.trigger = try container.decode(PMLocalNotificationTimeIntervalTrigger.self, forKey: .trigger)
        }
        
    }
}
