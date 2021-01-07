import UIKit

final class NextViewController: UIViewController {
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .random

        button.backgroundColor = .systemTeal
        button.setTitle("Next View", for: .normal)
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        view.addSubview(button)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutButton()
    }

    @objc private func didPressButton() {
        navigationController?.pushViewController(NextViewController(), animated: true)
    }

    private func layoutButton() {
        button.frame.size = CGSize(width: 200, height: 44)
        button.center = view.center
    }
}
