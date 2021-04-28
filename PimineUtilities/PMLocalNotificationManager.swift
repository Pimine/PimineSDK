//
//  PMLocalNotificationManager.swift
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

import NotificationCenter

public final class LocalPushNotificationScheduler {
    
    public struct Time: Codable {
        public let hour: Int
        public let minutes: Int
        public let seconds: Int
        public let weekday: Int
    }
    
    public struct Notification: Codable {
        public let title: String
        public let body: String
        public let time: Time
    }
    
    public struct Schedule: Codable {
        public let notifications: [Notification]
    }
    
    // MARK: Properties
    
    private static var pendingNotificationRequestIdentifiers: [String] = []
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: Methods
    
    public static func scheduleNotifications( _ schedule: Schedule, repeats: Bool, result: @escaping (Result<Void, Error>) -> Void) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: pendingNotificationRequestIdentifiers)
        pendingNotificationRequestIdentifiers = []
        
        let worker = DispatchGroup()
        var requestError: Error?
        
        for notification in schedule.notifications {
            worker.enter()
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            
            let time = notification.time
            var fireComponents = DateComponents()
            fireComponents.hour = time.hour
            fireComponents.minute = time.minutes
            fireComponents.second = time.seconds
            fireComponents.weekday = time.weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: fireComponents, repeats: repeats)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            let identifier = UUID().uuidString
            pendingNotificationRequestIdentifiers.append(identifier)
            notificationCenter.add(request) { error in
                if let error = error {
                    requestError = error
                }
                worker.leave()
            }
        }
        
        worker.notify(queue: .main) {
            requestError.isNil ?
                result(.success(())) :
                result(.failure(requestError!))
        }
    }
}

