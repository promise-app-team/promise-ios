//
//  SceneDelegate.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit
import KakaoSDKAuth
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UINavigationControllerDelegate {
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
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        // MARK: set delegate to scene delegate
        navigationController?.delegate = self
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light // 라이트모드만 지원하기
        //    self.window?.overrideUserInterfaceStyle = .dark // 다크모드만 지원하기
        }
        
        window.backgroundColor = .white // MARK: set default color
        window.rootViewController = navigationController // MARK: set root vc to navigation controllor with lanch vc
        window.makeKeyAndVisible() // MARK: visible navigation controllor with lanch vc
        
        // onboarding: check token, other...
        let onboarding = Onboarding()
        onboarding.ready { [weak self] startVC in
            self?.navigationController?.pushViewController(startVC, animated: true)
        }
    }
    
    // MARK: call after push animation and view did appear
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // MARK: launch vc pop after push animation with main vc for memory
        if viewController is MainVC || viewController is SignInVC {
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
        return navigationController?.viewControllers.count ?? 0 > 1
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

