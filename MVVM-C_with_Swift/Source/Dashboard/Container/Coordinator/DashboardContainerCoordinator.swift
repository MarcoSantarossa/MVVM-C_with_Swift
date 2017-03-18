//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxSwift

final class DashboardContainerCoordinator: Coordinator {

    private var childCoordinators = [Coordinator]()

    private weak var dashboardContainerViewController: DashboardContainerViewController?
    private weak var navigationController: UINavigationControllerType?

    private let disposeBag = DisposeBag()

    init(navigationController: UINavigationControllerType) {
        self.navigationController = navigationController
    }

    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = DashboardContainerViewModel()
        let container = DashboardContainerViewController(viewModel: viewModel)

        bindShouldLoadWidget(from: viewModel)

        navigationController.pushViewController(container, animated: true)
        
        dashboardContainerViewController = container
    }

    private func bindShouldLoadWidget(from viewModel: DashboardContainerViewModel) {
        viewModel.rx_shouldLoadWidget.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.loadWidgets()
            })
            .addDisposableTo(disposeBag)
    }

    func loadWidgets() {
        guard let containerViewController = usersContainerViewController() else { return }
        let coordinator = UsersCoordinator(containerViewController: containerViewController)
        coordinator.start()
        
        childCoordinators.append(coordinator)
    }

    private func usersContainerViewController() -> ContainerViewController? {
        guard let dashboardContainerViewController = dashboardContainerViewController else { return nil }

        return ContainerViewController(parentViewController: dashboardContainerViewController,
                                       containerView: dashboardContainerViewController.usersContainerView)
    }
}
