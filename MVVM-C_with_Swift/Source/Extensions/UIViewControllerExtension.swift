//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxSwift
import UIKit

extension UIViewController: UIViewControllerType {
    var viewType: UIViewType {
        return self.view
    }

    func addFillerChildViewController(_ childController: UIViewControllerType, toView: UIViewType? = nil) {
        addChildViewController(childController)
        var parentView: UIViewType = childController.viewType
        if let toView = toView {
            parentView = toView
        }
        parentView.addFillerSubview(childController.viewType)
        childController.didMove(toParentViewController: self)
    }

    func addChildViewController(_ childController: UIViewControllerType) {
        guard let childController = childController as? UIViewController else { return }
        addChildViewController(childController)
    }

    func didMove(toParentViewController parent: UIViewControllerType?) {
        didMove(toParentViewController: parent as? UIViewController)
    }
}

extension Reactive where Base: UIViewController {

    var viewDidLoad: Observable<Void> {
        return self.sentMessage(#selector(Base.viewDidLoad)).map { _ in Void() }
    }
}
