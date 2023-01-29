//
public struct AsyncValidation<Value>: AsyncValidator {
  
  @usableFromInline
  let closure: (Value) async throws -> ()
  
  @inlinable
  public init<V: AsyncValidator>(@AsyncValidationBuilder<Value> _ build: () -> V) where Value == V.Value {
    self.init(build())
  }
  
  @inlinable
  public init<V: Validator>(@ValidationBuilder<Value> _ build: () -> V) where Value == V.Value {
    self.init(build().async)
  }
  
  @inlinable
  public init(_ validate: @escaping (Value) async throws -> ()) {
    self.closure = validate
  }
  
  @inlinable
  public init<V: AsyncValidator>(_ validator: V) where V.Value == Value {
    self.closure = validator.validate(_:)
  }
  
  /// Transofrms a synchronous validator into an asynchronous one.
  ///
  ///
  @inlinable
  public init<V: Validator>(_ validator: V) where V.Value == Value {
    self.closure = { value in
      try validator.validate(value)
    }
  }
//  /// Wraps a synchronous validator and makes it an asynchronous validator.
//  @inlinable
//  public init<V: Validator>(_ validator: V) where V.Value == Value {
//    self.closure = { try validator.validate($0) }
//  }
//
  @inlinable
  public func validate(_ value: Value) async throws {
    try await closure(value)
  }
}

public typealias AsyncValidatorOf<Value> = Validation<Value>
