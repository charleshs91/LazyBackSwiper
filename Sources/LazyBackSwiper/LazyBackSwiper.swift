#if os(iOS) || os(tvOS)
import UIKit

public final class LazyBackSwiper: NSObject {
    public struct PopThreshold {
        public static let `default` = PopThreshold(transitionProgress: 0.4, panVelocity: 1000)

        public let transitionProgress: CGFloat

        public let panVelocity: CGFloat

        public init(transitionProgress: CGFloat, panVelocity: CGFloat) {
            self.transitionProgress = transitionProgress
            self.panVelocity = panVelocity
        }
    }

    public weak var animatorDelegate: LazyBackAnimatorDelegate? {
        didSet {
            animator.delegate = animatorDelegate
        }
    }

    private let navigationController: UINavigationController

    private let threshold: PopThreshold

    private let animator: LazyBackAnimator

    private var interactionController: UIPercentDrivenInteractiveTransition?

    private var panRecognizer: DirectionalPanGestureRecognizer!

    private var isAnimating: Bool = false

    public init(navigationController: UINavigationController, threshold: PopThreshold = .default) {
        self.navigationController = navigationController
        self.threshold = threshold
        animator = LazyBackAnimator()

        super.init()

        panRecognizer = DirectionalPanGestureRecognizer(target: self, action: #selector(pan(_:)), direction: .right)
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        navigationController.view.addGestureRecognizer(panRecognizer)
    }

    @objc
    private func pan(_ recognizer: UIPanGestureRecognizer) {
        var transitionProgress: CGFloat {
            let translation = recognizer.translation(in: navigationController.view)
            return max(translation.x / navigationController.view.bounds.width, 0)
        }

        switch recognizer.state {
        case .began:
            guard !isAnimating, navigationController.viewControllers.count > 1 else { return }

            interactionController = UIPercentDrivenInteractiveTransition()
            interactionController?.completionCurve = .easeOut
            navigationController.popViewController(animated: true)

        case .changed:
            interactionController?.update(transitionProgress)

        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: navigationController.view)

            if transitionProgress > threshold.transitionProgress || velocity.x > threshold.panVelocity {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
                isAnimating = false
            }
            interactionController = nil

        default:
            break
        }
    }
}

extension LazyBackSwiper: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return animator
        }
        return nil
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if animated {
            isAnimating = true
        }
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        isAnimating = false
        panRecognizer.isEnabled = navigationController.viewControllers.count > 1
    }
}

extension LazyBackSwiper: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
}

#endif
