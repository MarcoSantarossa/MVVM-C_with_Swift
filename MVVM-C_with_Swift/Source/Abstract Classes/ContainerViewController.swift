//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

class ContainerViewController {
    let parentViewController: UIViewControllerType
    let containerView: UIViewType

    init(parentViewController: UIViewControllerType, containerView: UIViewType) {
        self.parentViewController = parentViewController
        self.containerView = containerView
    }

    func addChildController(_ childController: UIViewControllerType) {
        parentViewController.addFillerChildViewController(childController, toView: containerView)
    }
}
