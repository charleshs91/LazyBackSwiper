import UIKit
import LazyBackSwiper

final class NextViewController: UIViewController {
    private var lazySwiper: LazyBackSwiper?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        if let navigationController = navigationController {
            lazySwiper = LazyBackSwiper(navigationController: navigationController)
            navigationController.delegate = lazySwiper
        }
    }
}
