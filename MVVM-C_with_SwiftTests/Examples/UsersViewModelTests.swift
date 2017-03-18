//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

@testable import MVVMC_with_Swift
import RxBlocking
import RxCocoa
import RxSwift
import RxTest
import XCTest

class UsersViewModelTests: XCTestCase {

    var viewModel: UsersViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        let dataProvider = MockUsersDataProvider()
        viewModel = UsersViewModel(dataProvider: dataProvider)
    }

    override func tearDown() {
        disposeBag = nil
        viewModel = nil

        super.tearDown()
    }

    func test_Init_TwoUsersFetched_UsersCountInfoEmitsRightString() {
        do {
            let res = try viewModel.rx_usersCountInfo
                .toBlocking(timeout: 2)
                .last()

            XCTAssertEqual(res, "The system has 2 users")
        } catch {
            XCTFail()
        }
    }

    func test_UserSearchQueryEmitsValue_ValidUserId_UserFoundEmitsRightString() {
        let resolution: TimeInterval = 0.2
        let stringValues = [
            "id1": "1",
            "id2": "2",
            "e": ""
        ]
        let validations = [
            "C": "I found Clark Kent aka Superman",
            "B": "I found Bruce Wayne aka Batman"
        ]

        let scheduler = TestScheduler(initialClock: 0, resolution: resolution, simulateProcessingDelay: false)
        let userSearchQueryEvents = scheduler.parseEventsAndTimes(timeline:     "e---id1----id2-", values: stringValues).first!
        let userFoundExpectedEvents = scheduler.parseEventsAndTimes(timeline:   "----C------B---", values: validations).first!

        driveOnScheduler(scheduler) {
            viewModel.bindUserSearchQuery(scheduler.createHotObservable(userSearchQueryEvents).asObservable())
            let recordedUserFound = scheduler.record(source: viewModel.rx_userFound)
            scheduler.start()

            XCTAssertEqual(recordedUserFound.events, userFoundExpectedEvents)
        }
    }
}

private class MockUsersDataProvider: UsersDataProviderType {
    func fetchData(endpoint: String) -> Observable<[UserModel]> {
        let user = UserModel(id: 1, name: "Clark Kent", username: "Superman")
        let user1 = UserModel(id: 2, name: "Bruce Wayne", username: "Batman")
        return .just([user, user1])
    }
}
