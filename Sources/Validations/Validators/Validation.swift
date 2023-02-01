/// A concrete validator that can be used to build a validator with a closure, by wrapping another validator, or
/// by using the builder syntax to create a validator.
///
/// **Example**
/// ```swift
/// let nonEmptyString = Validation<String> {
///   NotEmtpy()
/// }
///
/// try nonEmptyString.validate("foo") // success.
/// try nonEmptyString.validate("") // fails.
///```
///
public struct Validation<Value>: Validator {

  @usableFromInline
  let closure: (Value) throws -> Void

  /// Create a validation using a closure that validates the value.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let blobValidator = Validation<String> { string in
  ///   guard string == "blob" else {
  ///     throw ValidationError(message: "\(string) is not blob!")
  ///   }
  /// }
  ///```
  @inlinable
  public init(_ validate: @escaping (Value) throws -> Void) {
    self.closure = validate
  }

  /// Create a validation wrapping an already existing validator.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let notEmptyString = Validation<String>(NotEmpty())
  /// ```
  @inlinable
  public init<V: Validator>(_ validator: V) where V.Value == Value {
    self.init(validator.validate(_:))
  }

  /// Create a validation using the builder syntax.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let emailValidator = Validation<String> {
  ///   NotEmpty()
  ///   Contains("@")
  /// }
  /// ```
  @inlinable
  public init<V: Validator>(@ValidationBuilder<Value> _ build: () -> V) where Value == V.Value {
    self.init(build())
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try closure(value)
  }
}

/// Convenience naming for making concrete validations.
///
public typealias ValidatorOf<Value> = Validation<Value>
