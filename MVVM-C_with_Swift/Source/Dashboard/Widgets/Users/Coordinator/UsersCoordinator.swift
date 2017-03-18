//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxSwift
import UIKit

final class UsersCoordinator: Coordinator {

    private weak var containerViewController: ContainerViewController?

    init(containerViewController: ContainerViewController) {
        self.containerViewController = containerViewController
    }
    
    func start() {
        guard let containerViewController = containerViewController else { return }

        let dataProvider = UsersDataProvider()
        let viewModel = UsersViewModel(dataProvider: dataProvider)
        let usersViewController = UsersViewController(viewModel: viewModel)
        containerViewController.addChildController(usersViewController)
    }
}
