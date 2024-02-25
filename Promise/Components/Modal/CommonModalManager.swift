//
//  CommonModalManager.swift
//  Promise
//
//  Created by dylan on 2023/09/29.
//

import Foundation
import UIKit

@objc protocol CommonModalManagerDelegate: AnyObject {
    @objc optional func onWillShow()
    @objc optional func onDidShow()
    @objc optional func onWillHide()
    @objc optional func onDidHide()
}

protocol ModalViewControllerDelegate: AnyObject {
    func onWillShow()
    func onDidShow()
    func onWillHide()
    func onDidHide()
}

class ModalViewController: UIViewController {
    weak var delegate: ModalViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onWillShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.onDidShow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onWillHide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.onDidHide()
    }
}

class CommonModalManager: NSObject, UIViewControllerTransitioningDelegate, ModalViewControllerDelegate {
    static let shared = CommonModalManager()
    weak var delegate: CommonModalManagerDelegate?
    
    private var modalViewController: UIViewController?
    
    func show(content: UIView, from parentViewController: UIViewController) {
        let modalViewController = ModalViewController()
        modalViewController.delegate = self
        self.modalViewController = modalViewController
        
        content.translatesAutoresizingMaskIntoConstraints = false
        modalViewController.view.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: modalViewController.view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: modalViewController.view.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: modalViewController.view.bottomAnchor)
        ])
        
        // MARK: 순서 중요! 강제 업데이트로 컨텐츠의 레이아웃이 바뀌면 사이즈가 새롭게 결정된다. 그 이후 preferredContentSize를 설정한다.
        modalViewController.view.layoutIfNeeded()
        modalViewController.preferredContentSize = content.frame.size
        
        modalViewController.view.layer.cornerRadius = adjustedValue(20, .width)
        modalViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        modalViewController.view.layer.borderWidth = adjustedValue(1, .width)
        modalViewController.view.layer.borderColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1).cgColor
        
        modalViewController.view.layer.masksToBounds = true
        modalViewController.view.clipsToBounds = true
        
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        
        parentViewController.present(modalViewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        modalViewController?.dismiss(animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SlideUpAnimator()
        
        animator.safeAreaBottomInset = presenting.view.safeAreaInsets.bottom
        animator.direction = .presenting
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SlideUpAnimator()
        
        animator.safeAreaBottomInset = dismissed.view.safeAreaInsets.bottom
        animator.direction = .dismissing
        
        return animator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func onWillShow() {
        delegate?.onWillShow?()
    }
    
    func onWillHide() {
        delegate?.onWillHide?()
    }
    
    func onDidShow() {
        delegate?.onDidShow?()
    }
    
    func onDidHide() {
        delegate?.onDidHide?()
    }
}

class SlideUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var safeAreaBottomInset: CGFloat = 0.0
    
    enum AnimationDirection {
        case presenting, dismissing
    }
    var direction: AnimationDirection = .presenting
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: direction == .presenting ? .to : .from)!)
        
        if direction == .presenting, let toView = transitionContext.view(forKey: .to) {
            let initialFrame = CGRect(x: finalFrame.minX, y: containerView.frame.height + safeAreaBottomInset, width: finalFrame.width, height: finalFrame.height)
            toView.frame = initialFrame
            containerView.addSubview(toView)
        }
        
        if direction == .dismissing, let fromView = transitionContext.view(forKey: .from) {
            containerView.addSubview(fromView)
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            if self.direction == .presenting, let toView = transitionContext.view(forKey: .to) {
                toView.frame = finalFrame
            }
            
            if self.direction == .dismissing, let fromView = transitionContext.view(forKey: .from) {
                fromView.frame = CGRect(x: finalFrame.minX, y: containerView.frame.height + self.safeAreaBottomInset, width: finalFrame.width, height: finalFrame.height)
            }
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class CustomPresentationController: UIPresentationController {
    
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        dimmingView.addGestureRecognizer(tapGesture)
        
        dimmingView.alpha = 0.0
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
            }, completion: { _ in
                self.dimmingView.removeFromSuperview()
            })
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect.zero
        frame.size = presentedViewController.preferredContentSize
        frame.origin.y = containerView!.frame.height - frame.size.height
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
