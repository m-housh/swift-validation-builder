extension AsyncValidation {

  /// Wraps this validation with a type erasure.
  ///
  /// - Returns: An ``AnyAsyncValidator`` wrapping this validation.
  ///
  @inlinable
  public func eraseToAnyAsyncValidator() -> AnyAsyncValidator<Value> {
    AnyAsyncValidator(self)
  }
}

/// A type-erassed ``AsyncValidation`` of `Value`.
///
/// This uses and arbitrary underlying validation calling it's ``AsyncValidation/validate(_:)-7q3cb`` method,
/// hiding the specifics of the underlying validation.
///
/// Use ``AnyAsyncValidator`` to wrap a validation whose details you would like not to expose over api boundaries,
/// such as different modules, so that the underlying validation logic may chanage without affecting existing clients.
///
public struct AnyAsyncValidator<Value>: AsyncValidation {

  @usableFromInline
  let closure: (Value) async throws -> Void

  /// Create an ``AnyAsyncValidator`` type-erasing the given validation.
  ///
  /// Equivalent to calling ``AsyncValidation/eraseToAnyAsyncValidator()`` on the validation.
  ///
  /// - Parameters:
  ///   - validator: The underlying validation to wrap.
  ///
  @inlinable
  public init<V: AsyncValidation>(_ validator: V) where V.Value == Value {
    self.closure = validator.validate(_:)
  }

  /// Create an ``AnyAsyncValidator`` that wraps the given closure as it's `validate` method.
  ///
  /// - Parameters:
  ///   - closure: A closure that attempts to validate a value.
  ///
  @inlinable
  public init(_ closure: @escaping (Value) async throws -> Void) {
    self.closure = closure
  }

  @inlinable
  public func validate(_ value: Value) async throws {
    try await closure(value)
  }

  @inlinable
  public func eraseToAnyAsyncValidator() -> Self {
    // don't wrap ourself again, just return  this instance.
    self
  }
}
