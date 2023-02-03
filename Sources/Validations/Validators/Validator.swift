/// A concrete validator that can be used to build a validator with a closure, by wrapping another validator, or
/// by using the builder syntax to create a validator.
///
/// **Example**
/// ```swift
/// let nonEmptyString = Validator<String> {
///   Validators.NotEmtpy()
/// }
///
/// try nonEmptyString.validate("foo") // success.
/// try nonEmptyString.validate("") // fails.
///```
///
public struct Validator<Value>: Validation {

  public let validators: any Validation<Value>

  /// Create a validation wrapping an already existing validator.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let notEmptyString = Validator<String>(Validators.NotEmpty())
  /// ```
  @inlinable
  public init<V: Validation>(_ validators: V) where V.Value == Value {
    self.validators = validators
  }

  /// Create a validation using the builder syntax.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let validator = Validator<String> {
  ///   String.notEmpty()
  ///   String.contains("@")
  /// }
  /// ```
  @inlinable
  public init<V: Validation>(
    @ValidationBuilder<Value> _ build: () -> V
  )
  where V.Value == Value {
    self.init(build())
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try validators.validate(value)
  }
}

/// Convenience naming for making concrete validations.
///
public typealias ValidatorOf<Value> = Validator<Value>
