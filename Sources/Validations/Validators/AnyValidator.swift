extension Validation {

  /// Wraps this validation with a type erasure.
  ///
  /// - Returns: An ``AnyValidator`` wrapping this validation.
  @inlinable
  public func eraseToAnyValidator() -> AnyValidator<Value> {
    AnyValidator(self)
  }

}

/// A type-erased validator of `Value`.
///
/// This uses an arbitrary underlying validation, calling it's ``Validation/validate(_:)-2k2v0`` method,
/// hiding the specifics of the underlying validation.
///
/// Use ``AnyValidator``  to wrap a validation whose details you would like to not expose over api boundaries,
/// such as different modules, so that the underlying validation logic may change without affecting existing clients.
public struct AnyValidator<Value>: Validation {

  @usableFromInline
  let closure: (Value) throws -> Void

  /// Create a type-erased validation to wrap the given validation.
  ///
  /// Equivalent to calling ``Validation/eraseToAnyValidator()`` on the validation.
  ///
  /// - Parameters:
  ///   - validator: The underlying validation to wrap.
  @inlinable
  public init<V: Validation>(_ validator: V) where V.Value == Value {
    self.closure = validator.validate(_:)
  }

  /// Create a validation that wraps the given closure in it's validate method.
  ///
  ///  - Parameters:
  ///   - closure:  A closure that attempts to validate a value.
  @inlinable
  public init(_ closure: @escaping (Value) throws -> Void) {
    self.closure = closure
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try closure(value)
  }

  @inlinable
  public func eraseToAnyValidator() -> Self {
    // don't wrap ourself again, just return this instance.
    self
  }
}
