// 
// LazyBackSwiper-demo
// Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit
import LazyBackSwiper

final class NextViewController: UIViewController {
    var lazySwiper: LazyBackSwiper?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        if let navigationController = navigationController {
            lazySwiper = LazyBackSwiper(navigationController: navigationController)
            navigationController.delegate = lazySwiper
        }
    }
}
