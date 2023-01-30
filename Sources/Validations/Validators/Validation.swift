public struct Validation<Value>: Validator {
  
  @usableFromInline
  let closure: (Value) throws -> ()
  
  @inlinable
  public init(_ validate: @escaping (Value) throws -> ()) {
    self.closure = validate
  }
  
  @inlinable
  public init<V: Validator>(_ validator: V) where V.Value == Value {
    self.init(validator.validate(_:))
  }
  
  @inlinable
  public init<V: Validator>(@ValidationBuilder<Value> _ build: () -> V) where Value == V.Value {
    self.init(build())
  }
  
  @inlinable
  public func validate(_ value: Value) throws {
    try closure(value)
  }
}

public typealias ValidatorOf<Value> = Validation<Value>
