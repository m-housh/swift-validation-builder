public struct True<Value>: Validator {

  @usableFromInline
  let closure: (Value) -> Bool

  @inlinable
  public init(_ closure: @escaping (Value) -> Bool) {
    self.closure = closure
  }

  public func validate(_ value: Value) throws {
    guard closure(value) == true else {
      throw ValidationError.failed(summary: "Expected to evaluate to true.")
    }
  }
}

extension True where Value == Bool {

  @inlinable
  public init() {
    self.init({ bool in
      return bool
    })
  }
}
