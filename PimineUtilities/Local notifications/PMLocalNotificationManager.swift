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

#if(canImport(NotificationCenter))
import NotificationCenter

public final class PMLocalNotificationManager {
    
    struct Keys {
        static let pendingNotificationRequestIdentifiers = "pendingNotificationRequestIdentifiers"
    }
    
    // MARK: Properties
    
    @UserDefaultsBacked(key: Keys.pendingNotificationRequestIdentifiers, defaultValue: [])
    public private(set) static var pendingNotificationRequestIdentifiers: Set<String>
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: Methods
    
    public static func cancelPendingNotificationRequests() {
        cancelPendingNotificationRequests(with: pendingNotificationRequestIdentifiers)
    }
    
    public static func cancelPendingNotificationRequests(with identifiers: Set<String>) {
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: Array(identifiers)
        )
        identifiers.forEach {
            pendingNotificationRequestIdentifiers.remove($0)
        }
    }
    
    public static func scheduleNotifications(
        _ notifications: [PMLocalNotification],
        result: ((Result<Set<String>, Error>) -> Void)? = nil
    ) {
        let worker = DispatchGroup()
        var identifiers = Set<String>()
        var requestError: Error?
        
        for notification in notifications {
            worker.enter()
            
            let content = UNMutableNotificationContent()
            content.title = notification.content.title
            content.body = notification.content.body
            content.userInfo = notification.content.userInfo
            content.sound = .default
            
            let trigger = notification.trigger.notificationTrigger
            
            let identifier = UUID().uuidString
            pendingNotificationRequestIdentifiers.insert(identifier)
            identifiers.insert(identifier)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            notificationCenter.add(request) { error in
                if let error = error {
                    requestError = error
                }
                worker.leave()
            }
        }
        
        worker.notify(queue: .main) {
            requestError.isNil ?
                result?(.success(identifiers)) :
                result?(.failure(requestError!))
        }
    }
}

#endif
