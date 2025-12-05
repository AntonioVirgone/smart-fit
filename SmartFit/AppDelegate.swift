//
//  AppDelegate.swift
//  SmartFit
//
//  Created by Antonio Virgone on 04/12/25.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()

        return true
    }

    // Richiesta permessi
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permessi notifica non concessi", error ?? "")
            }
        }
    }

    // Quando APNS restituisce il device token
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNS TOKEN:", token)

        // TODO: invia al backend NestJS
        Task {
            //await ApiService.shared.registerDeviceToken(token: token)
        }
    }

    // Errore nella registrazione
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Errore registrazione APNS:", error)
    }

    // Notifica ricevuta in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([ .banner, .sound ])
    }
}

