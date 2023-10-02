//
//  AppDelegate.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit
import KakaoSDKCommon
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // UIApplication.shared.registerForRemoteNotifications()
        registerForPushNotifications()
        pushNotiOnForeground()
        
        // MARK: 카카오 SDK 초기화(v2부터 필수)
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //APNs에 등록되면 자동으로 호출되는 함수로 디바이스 토큰을 가져올 수 있다.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    //에러처리
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        print(#function)
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)") //인증결과 표시
                if granted {
                    self.getNotificationSettings()
                    
                }
            }
    }
    
    func getNotificationSettings() {
        print(#function)
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                //APNs에 등록
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
    }
    
    func pushNotiOnForeground() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    // 앱이 foreground 상태일 때, 알림을 수신하면 자동 호출되는 함수.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function)
        completionHandler([.sound, .badge, .banner, .list])
    }
}

