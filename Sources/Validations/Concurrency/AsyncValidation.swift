/// A concrete asynchronous validator that can be used to build a validator with a closure, by wrapping another validator, or
/// by using the builder syntax to create a validator.
///
/// **Example**
/// ```swift
/// let nonEmptyString = AsyncValidation<String> {
///   NotEmtpy()
/// }
///
/// try await nonEmptyString.validate("foo") // success.
/// try await nonEmptyString.validate("") // fails.
///```
///
public struct AsyncValidation<Value>: AsyncValidator {

  @usableFromInline
  let closure: (Value) async throws -> Void

  /// Create an async validation using the builder syntax.
  ///
  /// **Example**
  /// ```swift
  /// let asyncIntValidator = AsyncValidation<Int> {
  ///   Equals(1)
  /// }
  ///
  /// try await asyncIntValidator.validate(1) // succeeds.
  /// try await asyncIntValidator.validate(2) // fails.
  /// ```
  @inlinable
  public init<V: AsyncValidator>(@AsyncValidationBuilder<Value> _ build: () -> V)
  where Value == V.Value {
    self.init(build())
  }

  @inlinable
  public init(_ validate: @escaping (Value) async throws -> Void) {
    self.closure = validate
  }

  @inlinable
  public init<V: AsyncValidator>(_ validator: V) where V.Value == Value {
    self.closure = validator.validate(_:)
  }

  /// Transofrms a synchronous validator into an asynchronous one.
  ///
  /// - Parameters:
  ///   - validator: The synchronous validator to transform.
  @inlinable
  public init<V: Validator>(_ validator: V) where V.Value == Value {
    self.closure = { value in
      try validator.validate(value)
    }
  }

  @inlinable
  public func validate(_ value: Value) async throws {
    try await closure(value)
  }
}

//public typealias AsyncValidatorOf<Value> = Validation<Value>
