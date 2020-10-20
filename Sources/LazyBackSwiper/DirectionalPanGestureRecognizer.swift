import UIKit

public final class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    public enum Direction {
        case right, down, left, up
    }

    public private(set) var isDragging: Bool = false

    private let direction: Direction

    /// Initializes an directional gesture-recognizer object with a target and an action selector.
    ///
    /// - parameters:
    ///     - target: An object that is the recipient of action messages sent by the receiver when it recognizes a gesture.
    ///               Nil is not a valid value.
    ///     - action: A selector that identifies the method implemented by the target to handle the gesture recognized by the receiver.
    ///               Nil is not a valid value.
    ///     - direction: The direction allowed to trigger the gesture.
    ///
    public init(target: Any?, action: Selector?, direction: Direction) {
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

extension DirectionalPanGestureRecognizer {
    /// Encapsulate `PanDirection` and value of velocity
    private struct Speed: Comparable {
        static func < (lhs: Speed, rhs: Speed) -> Bool {
            return lhs.value < rhs.value
        }

        let direction: Direction
        let value: CGFloat

        init(_ direction: Direction, value: CGFloat) {
            self.direction = direction
            self.value = value
        }
    }
}
