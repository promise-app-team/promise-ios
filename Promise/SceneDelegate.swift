//
//  SceneDelegate.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit
import KakaoSDKAuth
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        
        // MARK: create navigation controller with lanch vc
        navigationController = UINavigationController(rootViewController: OnboardingVC())
        navigationController?.isNavigationBarHidden = true
        
        // MARK: https://gyuios.tistory.com/147
        // navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // MARK: 아래는 한줄은 버그 유발 코드인듯
        // navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // MARK: set delegate to scene delegate
        navigationController?.delegate = self
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light // 라이트모드만 지원하기
            //    self.window?.overrideUserInterfaceStyle = .dark // 다크모드만 지원하기
        }
        
        window.backgroundColor = .white // MARK: set default color
        window.rootViewController = navigationController // MARK: set root vc to navigation controllor with lanch vc
        window.makeKeyAndVisible() // MARK: visible navigation controllor with lanch vc
        
        
        // 유니버설 링크를 통해 앱이 시작되었는지 확인
        var invitedPromiseId: String? = nil
        if let userActivity = connectionOptions.userActivities.first {
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                if let url = userActivity.webpageURL {
                    let path = url.path
                    
                    let regex = try! NSRegularExpression(pattern: "^/(share/)?([^/]+)(/|$)", options: [])
                    let nsRange = NSRange(path.startIndex..<path.endIndex, in: path)
                    
                    if let match = regex.firstMatch(in: path, options: [], range: nsRange) {
                        let promiseId = (path as NSString).substring(with: match.range(at: 2))
                        invitedPromiseId = promiseId
                    }
                }
            }
        }
        
        // onboarding: check token, other...
        let onboarding = Onboarding()
        onboarding.ready(invitedPromiseId: invitedPromiseId) { [weak self] startVC in
            self?.navigationController?.pushViewController(startVC, animated: true)
        }
    }
    
    // MARK: 앱이 iOS 메모리에 올라가있는 상태에서 Universal link를 클릭해서 메모리에 있는 앱이 포커스된 경우 실행됨.
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            let path = url.path
            
            let regex = try! NSRegularExpression(pattern: "^/(share/)?([^/]+)(/|$)", options: [])
            let nsRange = NSRange(path.startIndex..<path.endIndex, in: path)
            
            if let match = regex.firstMatch(in: path, options: [], range: nsRange) {
                let promiseId = (path as NSString).substring(with: match.range(at: 2))
                
                // TODO: 약속이 존재하는지 한번 확인하는 것도 있으면 좋을것 같음.
                
                if let user = UserService.shared.getUser() {
                    // MARK: 로그인 상태, 바로 참여 화면으로 이동.
                    
                    let hasSeenGuideAttendee = UserDefaults.standard.bool(forKey: UserDefaultConstants.Attendee.HAS_SEEN_GUIDE_ATTENDEE)
                    if hasSeenGuideAttendee {
                        // MARK: UserDefaults에 HAS_SEEN_GUIDE_ATTENDEE가 true면 메인화면으로 이동, promiseId injection
                        
                        let mainVC = MainVC(invitedPromiseId: promiseId)
                        self.navigationController?.pushViewController(mainVC, animated: true)
                        
                    } else {
                        // MARK: UserDefaults에 HAS_SEEN_GUIDE_ATTENDEE가 false면 참여자 가이드 화면으로 이동, promiseId injection
                        
                        let guideAttendeeVC = GuideAttendeeVC(promiseId: promiseId)
                        self.navigationController?.pushViewController(guideAttendeeVC, animated: true)
                        
                    }
                } else {
                    // MARK: 로그인 전, UserService 싱글톤 객체에 저장.
                    
                    UserService.shared.invitedPromiseId = promiseId
                }
            }
        }
    }
    
    // MARK: call after push animation and view did appear
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // MARK: launch vc pop after push animation with main vc for memory
        if viewController is MainVC || viewController is SignInVC || viewController is GuideAttendeeVC {
            self.navigationController?.viewControllers = [viewController]
            
            // MARK: check success poped launch vc
            DispatchQueue.main.async { [weak self] in
                if let viewControllers = self?.navigationController?.viewControllers {
                    print("Root VC in Navigation Controller Stack: ", viewControllers)
                }
            }
        }
    }
    
    // MARK: https://gyuios.tistory.com/147
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
    
    // MARK: 카카오 로그인을 위한 scene
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
                return
            }
            
            _ = GIDSignIn.sharedInstance.handle(url)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

