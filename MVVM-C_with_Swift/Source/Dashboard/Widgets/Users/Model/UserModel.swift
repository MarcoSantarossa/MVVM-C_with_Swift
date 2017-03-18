//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

import ObjectMapper

struct UserModel: Mappable {
    private(set) var id: Int?
    private(set) var name: String?
    private(set) var username: String?

    init(id: Int?, name: String?, username: String?) {
        self.id = id
        self.name = name
        self.username = username
    }

    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
    }
}
