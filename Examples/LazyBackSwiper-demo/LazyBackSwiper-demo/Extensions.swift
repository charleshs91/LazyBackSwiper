import UIKit

extension UIColor {
    static var random: UIColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return UIColor(red: red, green: green, blue: blue)!
    }

    /// Creates a color object using RGB component integer values ranging from 0 to 255 and the specified opacity.
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard (0...255) ~= red,
              (0...255) ~= green,
              (0...255) ~= blue
        else { return nil }

        let alpha = min(max(transparency, 0), 1)
        self.init(red: red.cgFloat / 255, green: green.cgFloat / 255, blue: blue.cgFloat / 255, alpha: alpha)
    }
}

extension BinaryInteger {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }

    var double: Double {
        return Double(self)
    }

    var float: Float {
        return Float(self)
    }
}
