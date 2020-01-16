/*********************************************
 *
 * This code is under the MIT License (MIT)
 *
 * Copyright (c) 2016 AliSoftware
 *
 *********************************************/

import UIKit

public protocol Reusable: class {
  static var reuseIdentifier: String { get }
}

public typealias NibReusable = Reusable & NibLoadable

public extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
