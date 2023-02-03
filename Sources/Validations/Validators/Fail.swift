extension Validators {
  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int> {
  ///   Accumulating {
  ///     Fail()
  ///     Equals(1)
  ///   }
  /// }
  ///
  /// try intValidator.validate(0) // fails with 2 errors.
  /// try intValidator.validate(1) // fails with 1 error.
  ///```
  ///
  public struct Fail<Value>: Validation {

    /// Create a  validation that always fails.
    ///
    ///
    @inlinable
    init() {}

    @inlinable
    public func validate(_ value: Value) throws {
      throw ValidationError.failed(summary: "Fail validation error.")
    }
  }
}


extension Validator {

  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int> {
  ///   Accumulating {
  ///     Validation.fail()
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
  public static func fail() -> Self {
    .init(Validations.Validators.Fail<Value>())
  }
}
