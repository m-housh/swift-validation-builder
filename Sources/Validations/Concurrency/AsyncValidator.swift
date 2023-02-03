/// A concrete asynchronous validator that can be used to build a validator with a closure, by wrapping another validator, or
/// by using the builder syntax to create a validator.
///
/// **Example**
/// ```swift
/// let nonEmptyString = AsyncValidator<String> {
///   Validators.NotEmtpy()
/// }
///
/// try await nonEmptyString.validate("foo") // success.
/// try await nonEmptyString.validate("") // fails.
///```
///
public struct AsyncValidator<Value>: AsyncValidation {

  public let validators: any AsyncValidation<Value>

  @inlinable
  public init<V: AsyncValidation>(_ validator: V) where V.Value == Value {
    self.validators = validator
  }

  /// Create an async validation using the builder syntax.
  ///
  /// **Example**
  /// ```swift
  /// let asyncIntValidator = AsyncValidator<Int> {
  ///   Int.equals(1)
  /// }
  ///
  /// try await asyncIntValidator.validate(1) // succeeds.
  /// try await asyncIntValidator.validate(2) // fails.
  /// ```
  @inlinable
  public init<V: AsyncValidation>(
    @AsyncValidationBuilder<Value> _ build: () -> V
  )
  where Value == V.Value {
    self.init(build())
  }

  /// Transofrms a synchronous validator into an asynchronous one.
  ///
  /// - Parameters:
  ///   - validator: The synchronous validator to transform.
  @inlinable
  public init<V: Validation>(_ validator: V) where V.Value == Value {
    self.init(AnyAsyncValidator({ try validator.validate($0) }))
  }

  @inlinable
  public func validate(_ value: Value) async throws {
    try await validators.validate(value)
  }
}

public typealias AsyncValidatorOf<Value> = AsyncValidator<Value>
