// 
// LazySwipeBack
// Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

public final class LazyBackSwiper: NSObject {
    public weak var animatorDelegate: LazyBackAnimatorDelegate? {
        didSet { animator.delegate = animatorDelegate }
    }

    private let navigationController: UINavigationController
    private let animator: LazyBackAnimator

    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var panRecognizer: UIPanGestureRecognizer?
    private var duringAnimation: Bool = false

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        animator = LazyBackAnimator()
        super.init()

        let panRecognizer = DirectionalPanGestureRecognizer(target: self, action: #selector(pan(_:)), direction: .right)
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        navigationController.view.addGestureRecognizer(panRecognizer)
        self.panRecognizer = panRecognizer
    }

    @objc private func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if !duringAnimation && navigationController.viewControllers.count > 1 {
                interactionController = UIPercentDrivenInteractiveTransition()
                interactionController?.completionCurve = .easeOut
                navigationController.popViewController(animated: true)
            }
        case .changed:
            let translation = recognizer.translation(in: navigationController.view)
            let percent: CGFloat = max(translation.x / CGFloat(navigationController.view.bounds.width), 0)
            interactionController?.update(percent)
        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: navigationController.view)
            let translation = recognizer.translation(in: navigationController.view)
            let width = navigationController.view.frame.width

            if translation.x > width / 2 || velocity.x > 1000 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
                duringAnimation = false
            }
            interactionController = nil
        default:
            break
        }
    }
}

extension LazyBackSwiper: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return animator
        }
        return nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated {
            duringAnimation = true
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        duringAnimation = false
        panRecognizer?.isEnabled = navigationController.viewControllers.count > 1
    }
}

extension LazyBackSwiper: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
}
