import UIKit

final class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pushNextView(_ sender: Any) {
        let nextViewController = NextViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
