extension KeyPath {
  @inlinable
  func value(from root: Root) -> Value {
    root[keyPath: self]
  }
}
