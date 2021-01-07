import LazyBackSwiper
import UIKit

final class FirstViewController: UIViewController {
    private var lazySwiper: LazyBackSwiper?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationController = navigationController {
            lazySwiper = LazyBackSwiper(navigationController: navigationController)
            navigationController.delegate = lazySwiper
        }
    }

    @IBAction func pushNextView(_ sender: Any) {
        let nextViewController = NextViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
