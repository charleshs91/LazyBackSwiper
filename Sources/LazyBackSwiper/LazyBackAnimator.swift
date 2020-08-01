import UIKit

public protocol LazyBackAnimatorDelegate: AnyObject {
    func transitionDuration(_ animator: LazyBackAnimator) -> TimeInterval
    func dimmingAmount(_ animator: LazyBackAnimator) -> CGFloat
    func parallaxRatio(_ animator: LazyBackAnimator) -> CGFloat
}

public extension LazyBackAnimatorDelegate {
    func transitionDuration(_ animator: LazyBackAnimator) -> TimeInterval { return LazyBackAnimator.transitionDurationDefault }
    func dimmingAmount(_ animator: LazyBackAnimator) -> CGFloat { return LazyBackAnimator.dimmingAmountDefault }
    func parallaxRatio(_ animator: LazyBackAnimator) -> CGFloat { return LazyBackAnimator.parallaxRatioDefault }
}

public final class LazyBackAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let dimmingAmountDefault: CGFloat = 0.5
    static let transitionDurationDefault: TimeInterval = 0.3
    static let parallaxRatioDefault: CGFloat = 0.3

    public weak var delegate: LazyBackAnimatorDelegate?

    private weak var toViewController: UIViewController?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return delegate?.transitionDuration(self) ?? Self.transitionDurationDefault
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
        let parallaxRatio = delegate?.parallaxRatio(self) ?? Self.parallaxRatioDefault
        let toViewXTranslation: CGFloat = -containerView.bounds.width * parallaxRatio
        toView.bounds = containerView.bounds
        toView.center = containerView.center
        toView.transform = CGAffineTransform(translationX: toViewXTranslation, y: 0)

        // Add shadow to the left side of fromViewController's view
        let previousClipsToBounds = fromView.clipsToBounds

        // Make toViewController's view dimmer (with dimmingAmount hardcoded temporarily)
        let dimmingView = UIView(frame: toView.bounds)
        let dimmingAmmount = delegate?.dimmingAmount(self) ?? Self.dimmingAmountDefault
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(dimmingAmmount)
        toView.addSubview(dimmingView)

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
