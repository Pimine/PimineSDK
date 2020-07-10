//
//  PMUserNotificationManager.swift
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

import UIKit
import UserNotifications

public extension Notification.Name {
    static let userNotificationPreferencesChanged = Notification.Name("userNotificationPreferencesChanged")
}

final public class PMUserNotificationManager {
    
    struct Keys {
        static let inAppEnabled = "inAppEnabled"
        static let permissionGranted = "permissionGranted"
    }
    
    public struct Configuration {
        let authorizationOptions: UNAuthorizationOptions
        let allowRemoteNotifications: Bool
        let requestPermissionsOnLaunch: Bool
        
        public init(
            authorizationOptions: UNAuthorizationOptions,
            allowRemoteNotifications: Bool = true,
            requestPermissionsOnLaunch: Bool = false) {
            
            self.authorizationOptions = authorizationOptions
            self.allowRemoteNotifications = allowRemoteNotifications
            self.requestPermissionsOnLaunch = requestPermissionsOnLaunch
        }
    }
    
    // MARK: - Private properties
    
    private static let storage = UserDefaults(suiteName: "Pimine") ?? UserDefaults.standard
    
    private static let userNotificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Public properties
    
    public static var configuration = Configuration(authorizationOptions: [.alert, .badge, .sound]) {
        didSet { configure() }
    }
    
    @UserDefaultsBacked(key: Keys.inAppEnabled, defaultValue: true, storage: storage)
    public static var inAppEnabled: Bool {
        didSet { updateNotificationPreferences() }
    }
    
    @UserDefaultsBacked(key: Keys.permissionGranted, defaultValue: false, storage: storage)
    public private(set) static var permissionGranted: Bool {
        didSet { NotificationCenter.default.post(name: .userNotificationPreferencesChanged, object: nil) }
    }
    
    public static var notificationsEnabled: Bool {
        inAppEnabled && permissionGranted
    }
    
    // MARK: - Public methods
    
    public static func configure() {
        setupObservers()
        if configuration.requestPermissionsOnLaunch {
            return requestPermissions()
        }
        updateNotificationPreferences()
    }
    
    public static func requestPermissions(result: ((Bool) -> Void)? = nil) {
        userNotificationCenter.requestAuthorization(options: configuration.authorizationOptions) { (granted, error) in
            if let error = error { PMAlert.show(error: error) }
            self.updateNotificationPreferences(silently: false)
            DispatchQueue.main.async {
                result?(granted)
            }
        }
    }
    
    // MARK: - Private methods
    
    private static func setupObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(applicationDidBecomeActiveNotification),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    @objc private static func applicationDidBecomeActiveNotification() {
        updateNotificationPreferences()
    }
    
    private static func updateNotificationPreferences(silently: Bool = true) {
        userNotificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .provisional:
                    guard self.configuration.authorizationOptions.contains(.provisional) else { break }
                    fallthrough
                case .authorized:
                    self.permissionGranted = true
                    self.inAppEnabled ?
                        UIApplication.shared.registerForRemoteNotifications() :
                        UIApplication.shared.unregisterForRemoteNotifications()
                case .denied:
                    self.permissionGranted = false
                    UIApplication.shared.unregisterForRemoteNotifications()
                    guard !silently else { return }
                    setupPermissionsManually()
                case .notDetermined:
                    self.permissionGranted = false
                @unknown default:
                    break
                }
            }
        }
    }
    
    private static func setupPermissionsManually() {
        let alert = UIAlertController(
            title: UtilitiesMessages.whoops,
            message: UtilitiesMessages.permissionRequired,
            preferredStyle: .alert
        )
        
        let settings = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let appSettingsURL = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        }
        alert.addAction(settings)
        alert.preferredAction = settings
        
        let later = UIAlertAction(title: "Later", style: .cancel)
        alert.addAction(later)

        UIApplication.shared.topViewController?.present(alert, animated: true)
    }
}
