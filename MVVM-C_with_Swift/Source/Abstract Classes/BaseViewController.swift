//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxSwift
import UIKit

class BaseViewController<T>: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private(set) var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)

        configure(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: T) {}
}
