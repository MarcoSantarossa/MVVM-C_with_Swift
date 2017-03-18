//
//  MVVM-C_with_Swift
//
//  Copyright © 2017 Marco Santarossa. All rights reserved.
//

protocol UIViewType: class {
    // swiftlint:disable variable_name
    var translatesAutoresizingMaskIntoConstraints: Bool { get set }

    func addSubview(_ view: UIViewType)
    func addFillerSubview(_ subview: UIViewType)
}
