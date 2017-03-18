//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

protocol UsersDataProviderType {
    func fetchData(endpoint: String) -> Observable<[UserModel]>
}

final class UsersDataProvider: UsersDataProviderType {
    
    func fetchData(endpoint: String) -> Observable<[UserModel]> {
        guard let endpointUrl = URL(string: endpoint) else {
            fatalError("endpoint is not an URL object")
        }
        let req = URLRequest(url: endpointUrl)
        return URLSession.shared.rx.json(request: req)
            .flatMap(parseResponse)
    }
    
    private func parseResponse(data: Any) -> Observable<[UserModel]> {
        guard let json = data as? [[String: Any]],
            let users = self.parseUsers(from: json) else {
            let error = NSError(domain: "ParsingError", code: 0, userInfo: nil)
            return Observable.error(error)
        }

        return Observable.just(users)
    }

    private func parseUsers(from json: [[String: Any]]) -> [UserModel]? {
        return Mapper<UserModel>().mapArray(JSONArray: json)
    }
}
