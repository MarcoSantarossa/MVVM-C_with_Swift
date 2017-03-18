//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxCocoa
import RxSwift

protocol DashboardContainerViewModelType: class {
    var rx_title: Driver<String> { get }
    var rx_shouldLoadWidget: Observable<Void> { get }

    func bindViewDidLoad(_ observable: Observable<Void>)
}

final class DashboardContainerViewModel: DashboardContainerViewModelType {

    var rx_title: Driver<String> = .just("Dashboard")
    var rx_shouldLoadWidget: Observable<Void> = .never()

    private var disposableBag = DisposeBag()

    func bindViewDidLoad(_ observable: Observable<Void>) {
        rx_shouldLoadWidget = observable
    }
}
