extension KeyPath {
  @inlinable
  func value(from root: Root) -> Value {
    root[keyPath: self]
  }
  
  // MARK: - Experimental
  // for better error descriptions, but need a way to hold onto the key-paths.
//  @usableFromInline
//  var parentLabel: String {
//    let parent = Mirror(reflecting: Root.self)
//      .description
//      .split(separator: " ")
//      .last?.split(separator: ".")
//      .first ?? ""
//
//    return String(parent)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  func key(from root: Root) -> String {
//    parentLabel
//  }
}

//extension KeyPath where Value: Equatable {
//
//  @inlinable
//  func key(from root: Root) -> String {
//
//    let mirror = Mirror(reflecting: root)
//    let value = root[keyPath: self]
//
//    for child in mirror.children {
//      if let strongValue = child.value as? Value,
//         strongValue == value
//      {
//        guard let label = child.label else {
//          return parentLabel
//        }
//        return "\(parentLabel).\(label)"
//      }
//    }
//
//    return parentLabel
//  }
//}
