//
//  PMAccessManager.swift
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

import Photos
import UIKit

@available(iOSApplicationExtension, unavailable)
public final class PMAccessManager {
    
    public enum SourceType {
        case photoLibrary
        case camera
        case photoLibraryPicker
    }
    
    public static func obtainPermissions(
        for sourceType: SourceType,
        then permissionsGranted: @escaping () -> Void = { }
    ) {
        switch sourceType {
            
        // Photo library
            
        case .photoLibrary:
            let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            handlePhotoLibraryAuthorizationStatus(authorizationStatus, then: permissionsGranted)
            
        // Camera
            
        case .camera:
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            handleCameraAuthorizationStatus(authorizationStatus, then: permissionsGranted)
            
        // Photo library picker
        // For UIImagePickerController
        
        case .photoLibraryPicker:
            permissionsGranted()
        }
    }
    
    private static func handlePhotoLibraryAuthorizationStatus(
        _ authorizationStatus: PHAuthorizationStatus,
        then permissionsGranted: @escaping () -> Void
    ) {
        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    handlePhotoLibraryAuthorizationStatus(status, then: permissionsGranted)
                }
            }
        case .restricted, .denied:
            obtainPermissionsManually(message: PMessages.photoLibraryPermissionsRequired)
        case .authorized:
            permissionsGranted()
        @unknown default:
            break
        }
    }
    
    private static func handleCameraAuthorizationStatus(
        _ authorizationStatus: AVAuthorizationStatus,
        then permissionsGranted: @escaping () -> Void
    ) {
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                    handleCameraAuthorizationStatus(authorizationStatus, then: permissionsGranted)
                }
            }
        case .restricted, .denied:
            obtainPermissionsManually(message: PMessages.cameraLibraryPermissionsRequired)
        case .authorized:
            permissionsGranted()
        @unknown default:
            break
        }
    }
    
    private static func obtainPermissionsManually(message: String) {
        let denyAction = UIAlertAction(title: "Later", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open settings", style: .default) { (_) in
            let settingsURL = URL(string: UIApplication.openSettingsURLString)!
            guard UIApplication.shared.canOpenURL(settingsURL) else { return }
            UIApplication.shared.open(settingsURL, options: [:])
        }
        
        let alert = UIAlertController(
            title: PMessages.info,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(denyAction)
        alert.addAction(openAction)
        alert.preferredAction = openAction
        
        UIApplication.shared.topViewController?.present(alert, animated: true)
    }
}
