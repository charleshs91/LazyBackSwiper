import UIKit

fileprivate let kTransitionDuration: TimeInterval = 0.3
fileprivate let kDimmingAmount: CGFloat = 0.5
fileprivate let kParallaxRatio: CGFloat = 0.3

public protocol LazyBackAnimatorDelegate: AnyObject {
    func transitionDuration(_ animator: LazyBackAnimator) -> TimeInterval
    func dimmingAmount(_ animator: LazyBackAnimator) -> CGFloat
    func parallaxRatio(_ animator: LazyBackAnimator) -> CGFloat
}

public extension LazyBackAnimatorDelegate {
    /// Default is 0.3
    func transitionDuration(_ animator: LazyBackAnimator) -> TimeInterval {
        return kTransitionDuration
    }

    /// Default is 0.5
    func dimmingAmount(_ animator: LazyBackAnimator) -> CGFloat {
        return kDimmingAmount
    }

    /// Default is 0.3
    func parallaxRatio(_ animator: LazyBackAnimator) -> CGFloat {
        return kParallaxRatio
    }
}

public final class LazyBackAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public weak var delegate: LazyBackAnimatorDelegate?

    private weak var toViewController: UIViewController?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return delegate?.transitionDuration(self) ?? kTransitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toView = toViewController.view,
            let fromView = fromViewController.view
            else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)
        containerView.insertSubview(toView, belowSubview: fromView)

        // Parallax effect

        let parallaxRatio = delegate?.parallaxRatio(self) ?? kParallaxRatio
        let toViewXTranslation: CGFloat = -containerView.bounds.width * parallaxRatio
        toView.bounds = containerView.bounds
        toView.center = containerView.center
        toView.transform = CGAffineTransform(translationX: toViewXTranslation, y: 0)

        // Add shadow to the left side of fromViewController's view

        let previousClipsToBounds = fromView.clipsToBounds

        // Make toViewController's view dimmer

        let dimmingView = UIView(frame: toView.bounds)
        let dimmingAmmount = delegate?.dimmingAmount(self) ?? kDimmingAmount
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(dimmingAmmount)
        toView.addSubview(dimmingView)

        // Animate transitioning
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.transform = .identity
            fromView.transform = CGAffineTransform(translationX: toView.frame.width, y: 0)
            dimmingView.alpha = 0
        }) { _ in
            dimmingView.removeFromSuperview()
            fromView.clipsToBounds = previousClipsToBounds
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        self.toViewController = toViewController
    }

    public func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            toViewController?.view.transform = .identity
        }
    }
}
