extension Validators {
  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int> {
  ///   Accumulating {
  ///     Never()
  ///     Equals(1)
  ///   }
  /// }
  ///
  /// try intValidator.validate(0) // fails with 2 errors.
  /// try intValidator.validate(1) // fails with 1 error.
  ///```
  ///
  public struct Never<Value>: Validator {
    
    @inlinable
    init() {}
    
    @inlinable
    public func validate(_ value: Value) throws {
      throw ValidationError.failed(summary: "Never validation error.")
    }
  }
}

extension Validation {

  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int> {
  ///   Accumulating {
  ///     Validation.never()
  ///     Equals(1)
  ///   }
  /// }
  ///
  /// try intValidator.validate(0) // fails with 2 errors.
  /// try intValidator.validate(1) // fails with 1 error.
  ///```
  ///
  ///
  @inlinable
  public static func never() -> Self {
    .init(Validators.Never())
  }
}
