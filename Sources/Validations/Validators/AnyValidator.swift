extension Validation {

  public func eraseToAnyValidator() -> AnyValidator<Value> {
    AnyValidator(self)
  }

}

public struct AnyValidator<Value>: Validation {

  @usableFromInline
  let closure: (Value) throws -> Void

  @inlinable
  public init<V: Validation>(_ validator: V) where V.Value == Value {
    self.closure = validator.validate(_:)
  }

  @inlinable
  public init(_ validator: @escaping (Value) throws -> Void) {
    self.closure = validator
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try closure(value)
  }
}
