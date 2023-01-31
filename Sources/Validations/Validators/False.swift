

public struct False<Value>: Validator {
  
  @usableFromInline
  let closure: (Value) -> Bool
  
  @inlinable
  public init(_ closure: @escaping (Value) -> Bool) {
    self.closure = closure
  }
  
  @inlinable
  public func validate(_ value: Value) throws {
    guard closure(value) == false else {
      throw ValidationError.failed(summary: "Expected to evaluate to false.")
    }
  }
}

extension False where Value == Bool {
  
  @inlinable
  public init() {
    self.init({ bool in
      return bool
    })
  }
}
