//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class DashboardContainerViewController: BaseViewController<DashboardContainerViewModelType> {
    
    @IBOutlet private(set) weak var usersContainerView: UIView!

    override func configure(viewModel: DashboardContainerViewModelType) {
        viewModel.bindViewDidLoad(rx.viewDidLoad)

        viewModel.rx_title
            .drive(rx.title)
            .addDisposableTo(disposeBag)
    }
}
