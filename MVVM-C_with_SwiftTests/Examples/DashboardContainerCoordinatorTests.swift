//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

@testable import MVVMC_with_Swift

import XCTest

class DashboardContainerCoordinatorTests: XCTestCase {

    func test_Start_ContainerViewContollerIsPushedInNavigationController() {
        let mockNavigationController = MockNavigationController()
        let dashboardContainerCoordinator = DashboardContainerCoordinator(navigationController: mockNavigationController)

        dashboardContainerCoordinator.start()

        XCTAssertTrue(mockNavigationController.isPushCalled)
        XCTAssertNotNil(mockNavigationController.viewControllerPushed as? DashboardContainerViewController)
    }
}

private class MockNavigationController: UINavigationControllerType {

    var isPushCalled = false
    var viewControllerPushed: UIViewController?

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushCalled = true
        viewControllerPushed = viewController
    }

}
