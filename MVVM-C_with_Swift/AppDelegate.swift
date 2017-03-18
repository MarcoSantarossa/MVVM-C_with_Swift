//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }()

    private var mainCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = navigationController
        let coordinator = DashboardContainerCoordinator(navigationController: navigationController)
        coordinator.start()
        window?.makeKeyAndVisible()

        mainCoordinator = coordinator

        return true
    }
}
