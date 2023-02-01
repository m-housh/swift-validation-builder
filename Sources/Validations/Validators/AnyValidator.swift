extension Validator {
  
  public func eraseToAnyValidator() -> AnyValidator<Value> {
    AnyValidator(self)
  }
  
}
public struct AnyValidator<Value>: Validator {
  
  @usableFromInline
  let closure: (Value) throws -> ()
  
  @inlinable
  public init<V: Validator>(_ validator: V) where V.Value == Value {
    self.closure = validator.validate(_:)
  }
  
  @inlinable
  public init(_ validator: @escaping (Value) throws -> ()) {
    self.closure = validator
  }
  
  public func validate(_ value: Value) throws {
    try closure(value)
  }
}
