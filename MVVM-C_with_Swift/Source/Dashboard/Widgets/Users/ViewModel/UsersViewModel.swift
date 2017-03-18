//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import RxCocoa
import RxSwift

struct UserSearchPayload {
    let users: [UserModel]
    let query: String
}

protocol UsersViewModelType {
    var rx_shouldShowActivityIndicator: Driver<Bool> { get }
    var rx_shouldShowUsersSearchView: Driver<Bool> { get }
    var rx_usersCountInfo: Driver<String> { get }
    var rx_userFound: Driver<String> { get }
    var rx_userFoundDefault: Driver<String> { get }

    func bindUserSearchQuery(_ observable: Observable<String>)
}

final class UsersViewModel: UsersViewModelType {

    private var dataProvider: UsersDataProviderType
    private var rx_usersFetched: Observable<[UserModel]>

    lazy var rx_shouldShowActivityIndicator: Driver<Bool> = {
        return UsersViewModel.createShouldShowActivityIndicator(from: self.rx_usersFetched)
    }()
    lazy var rx_shouldShowUsersSearchView: Driver<Bool> = {
        return UsersViewModel.createShouldShowUsersSearchView(from: self.rx_usersFetched)
    }()
    lazy var rx_usersCountInfo: Driver<String> = {
        return UsersViewModel.createUsersCountInfo(from: self.rx_usersFetched)
    }()
    var rx_userFound: Driver<String> = .never()
    var rx_userFoundDefault: Driver<String> = .never()

    init(dataProvider: UsersDataProviderType) {
        self.dataProvider = dataProvider

        rx_usersFetched = dataProvider.fetchData(endpoint: "http://jsonplaceholder.typicode.com/users")
            .shareReplay(1)
    }

    func bindUserSearchQuery(_ observable: Observable<String>) {
        rx_userFound = UsersViewModel.createUserFound(from: self.rx_usersFetched, userSearchQuery: observable)
        rx_userFoundDefault = UsersViewModel.createUserFoundDefault(from: observable)
    }
}

// MARK: - Create Observables
extension UsersViewModel {
    fileprivate static func createShouldShowActivityIndicator(from usersFetched: Observable<[UserModel]>) -> Driver<Bool> {
        return usersFetched
            .flatMapLatest { _ in
                return Observable.just(false)
            }
            .startWith(true)
            .asDriver(onErrorJustReturn: true)
    }

    fileprivate static func createShouldShowUsersSearchView(from usersFetched: Observable<[UserModel]>) -> Driver<Bool> {
        return usersFetched
            .flatMapLatest { _ -> Observable<Bool> in
                return .just(true)
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }

    fileprivate static func createUsersCountInfo(from usersFetched: Observable<[UserModel]>) -> Driver<String> {
        return usersFetched
            .flatMapLatest { users -> Observable<String> in
                return .just("The system has \(users.count) users")
            }
            .asDriver(onErrorJustReturn: "")
    }

    fileprivate static func createUserFoundDefault(from userSearchQuery: Observable<String>) -> Driver<String> {
        return userSearchQuery
            .filter { $0.isEmpty }
            .map { _ in "---" }
            .asDriver(onErrorJustReturn: "---")
    }

    fileprivate static func createUserFound(from usersFetched: Observable<[UserModel]>, userSearchQuery: Observable<String>) -> Driver<String> {
        return Observable.combineLatest(usersFetched, userSearchQuery) { UserSearchPayload(users: $0, query: $1) }
            .filter { !$0.query.isEmpty }
            .flatMap(UsersViewModel.findUser)
            .catchErrorJustReturn(nil)
            .flatMap { user -> Observable<String> in
                guard let user = user,
                    let name = user.name,
                    let username = user.username else {
                        return Observable.just("User not found")
                }
                return Observable.just("I found \(name) aka \(username)")
            }
            .asDriver(onErrorJustReturn: "User not found")
    }

    private static func findUser(_ payload: UserSearchPayload) -> Observable<UserModel?> {
        let identifier = Int(payload.query)
        let user = payload.users.filter({ $0.id == identifier }).first

        return Observable.just(user)
    }
}
