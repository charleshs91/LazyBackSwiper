import UIKit

public final class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    public enum PanDirection {
        case right
        case down
        case left
        case up
    }

    public private(set) var isDragging: Bool = false

    private let direction: PanDirection

    /**
     - parameter direction: The direction allowed to trigger the gesture
     */
    public init(target: Any?, action: Selector?, direction: PanDirection) {
        self.direction = direction
        super.init(target: target, action: action)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard state != .failed, !isDragging, velocity(in: view) != .zero else { return }

        let directionSpeeds: [Speed] = [
            Speed(.right, value: velocity(in: view).x),
            Speed(.down, value: velocity(in: view).y),
            Speed(.left, value: -velocity(in: view).x),
            Speed(.up, value: -velocity(in: view).y)
        ]

        guard let maxSpeed = directionSpeeds.sorted().last, maxSpeed.direction == direction else {
            state = .failed
            return
        }

        isDragging = true
    }

    public override func reset() {
        super.reset()

        isDragging = false
    }
}

internal extension DirectionalPanGestureRecognizer {
    /// Encapsulate `PanDirection` and value of velocity
    struct Speed: Comparable {
        static func < (lhs: Speed, rhs: Speed) -> Bool {
            return lhs.value < rhs.value
        }

        let direction: PanDirection
        let value: CGFloat

        init(_ direction: PanDirection, value: CGFloat) {
            self.direction = direction
            self.value = value
        }
    }
}
