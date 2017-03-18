//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class UsersViewController: BaseViewController<UsersViewModelType> {

    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var usersSearchView: UIView!
    @IBOutlet private weak var usersCountInfoLabel: UILabel!
    @IBOutlet private weak var searchUserTextField: UITextField!
    @IBOutlet private weak var userFoundLabel: UILabel!

    private func bindToViewModel() {
        viewModel.rx_usersCountInfo
            .drive(usersCountInfoLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.bindUserSearchQuery(searchUserTextField.rx.text.orEmpty.asObservable())

        viewModel.rx_userFound
            .drive(userFoundLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.rx_userFoundDefault
            .drive(userFoundLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindActivityIndicatorVisibility()
        bindUsersSearchView()

        bindToViewModel()

        addTapGesture()
    }

    private func addTapGesture() {
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
}

// MARK: - Custom bindings
extension UsersViewController {
    fileprivate func bindActivityIndicatorVisibility() {
        viewModel.rx_shouldShowActivityIndicator
            .distinctUntilChanged()
            .drive(onNext: { [weak self] shouldShow in
                self?.updateActivityIndicatorVisibility(shouldShow)
            })
            .disposed(by: disposeBag)
    }

    fileprivate func updateActivityIndicatorVisibility(_ shouldShow: Bool) {
        if shouldShow {
            view.addFillerSubview(activityIndicator)
        } else {
            activityIndicator.removeFromSuperview()
        }
    }

    fileprivate func bindUsersSearchView() {
        viewModel.rx_shouldShowUsersSearchView
            .distinctUntilChanged()
            .drive(onNext: { [weak self] shouldShow in
                self?.updateUsersSearchViewVisibility(shouldShow)
            })
            .disposed(by: disposeBag)
    }

    fileprivate func updateUsersSearchViewVisibility(_ shouldShow: Bool) {
        if shouldShow {
            view.addFillerSubview(usersSearchView)
        } else if usersSearchView.superview != nil {
            usersSearchView.removeFromSuperview()
        }
    }
}
