//
//  ModalPresentationController.swift
//  Promise
//
//  Created by Sun on 2023/06/12.
//

import UIKit


enum ModalScaleState {
    case presentation
    case interaction
}

class ModalPresentationController: UIPresentationController {
    
    private let presentedYOffset: CGFloat = 100
    private var state: ModalScaleState = .interaction
    
    private lazy var dimmingView: UIView! = {
        guard let container = containerView else { return nil }
        
        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTap(tap:)))
        )
        
        return view
    }()
    
    // MARK: - 생성자
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        presentedViewController.view.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:)))
        )
        
        if presentedViewController is CommonModalViewConroller {
            print("same as common view controller")
        }
    }
    
    @objc func didPan(pan: UIPanGestureRecognizer) {
        guard let view = pan.view,
              let superView = view.superview,
              let presented = presentedView,
              let container = containerView else { return }
        
        let location = pan.translation(in: superView)
        
        switch pan.state {
        case .began:
            presented.frame.size.height = container.frame.height
            
        case .changed:
            switch state {
            case .interaction:
                presented.frame.origin.y = location.y + presentedYOffset
            case .presentation:
                presented.frame.origin.y = location.y
            }
            
            // 모달을 화면 top까지 끌어올렸을 때, 뷰가 더 위로 올라가지 않게 y = 0으로 set
            if presented.frame.origin.y <= 0 {
                presented.frame.origin.y = 0
            }
            
        case .ended:
            let maxPresentedY = container.frame.height - container.frame.height * 0.75
            switch presented.frame.origin.y {
            case 1...maxPresentedY:
                changeScale(to: .interaction)
            default:
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc func didTap(tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    func changeScale(to state: ModalScaleState) {
        guard let presented = presentedView else { return }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            guard let `self` = self else { return }
            
            presented.frame = self.frameOfPresentedViewInContainerView
            
        }, completion: { (isFinished) in
            self.state = state
        })
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        
        return CGRect(x: 0, y: self.presentedYOffset, width: container.bounds.width, height: container.bounds.height - self.presentedYOffset)
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView,
              let coordinator = presentingViewController.transitionCoordinator else { return }
        
        dimmingView.alpha = 0
        dimmingView.frame = container.bounds
        dimmingView.addSubview(presentedViewController.view)
        
        container.addSubview(dimmingView)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let `self` = self else { return }
            self.dimmingView.alpha = 0.5
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [weak self] (context) -> Void in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
}
