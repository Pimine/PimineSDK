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

#if(canImport(NotificationCenter))
import NotificationCenter

public struct PMNotificationAttachment: Codable {
    
    // MARK: Properties
    
    public let identifier: String
    public let url: URL
    
    // MARK: Initialization
    
    public init(identifier: String, url: URL) {
        self.identifier = identifier
        self.url = url
    }
}

public struct PMLocalNotificationContent: Codable {
    
    // MARK: Properties
    
    public let title: String
    public let body: String
    public let soundName: String?
    public let attachments: [PMNotificationAttachment]
    public let userInfo: [String: String]
    
    // MARK: Initialization
    
    /// - Parameters:
    ///   - soundName: Sound file name, e.g. `"reminder.mp3"`. If `nil`, default sound will be used. Default is `nil`.
    public init(
        title: String,
        body: String,
        soundName: String? = nil,
        attachments: [PMNotificationAttachment] = [],
        userInfo: [String: String] = [:]
    ) {
        self.title = title
        self.body = body
        self.soundName = soundName
        self.attachments = attachments
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
        case identifier
        case type
        case content
        case trigger
    }
    
    enum NotificationType: String, Decodable {
        case timeInterval
        case calendar
    }

    // MARK: Properties

    public let identifier: String
    public let content: PMLocalNotificationContent
    public let trigger: PMLocalNotificationTrigger
    
    // MARK: Initialization

    /// - Parameters:
    ///   - identifier: Notification identifier. Default is `UUID` string.
    public init(
        identifier: String = UUID().uuidString,
        content: PMLocalNotificationContent,
        trigger: PMLocalNotificationTrigger
    ) {
        self.identifier = identifier
        self.content = content
        self.trigger = trigger
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.identifier = (try? container.decodeIfPresent(String.self, forKey: .identifier)) ?? UUID().uuidString
        self.content = try container.decode(PMLocalNotificationContent.self, forKey: .content)

        let type = try container.decode(NotificationType.self, forKey: .type)
        switch type {
        case .calendar:
            self.trigger = try container.decode(PMLocalNotificationCalendarTrigger.self, forKey: .trigger)
        case .timeInterval:
            self.trigger = try container.decode(PMLocalNotificationTimeIntervalTrigger.self, forKey: .trigger)
        }
    }
}

#endif
