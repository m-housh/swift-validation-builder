extension Validators {
  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int> {
  ///   Validator.accumulating {
  ///     Validator.fail()
  ///     Int.equals(1)
  ///   }
  /// }
  ///
  /// try intValidator.validate(0) // fails with 2 errors.
  /// try intValidator.validate(1) // fails with 1 error.
  ///```
  ///
  public struct FailingValidator<ValidationType> {

    /// Create a  validation that always fails.
    ///
    ///
    @inlinable
    init() {}

  }
}

extension Validators.FailingValidator: Validation where ValidationType: Validation {

  @inlinable
  public func validate(_ value: ValidationType.Value) throws {
    throw ValidationError.failed(summary: "Fail validation error.")
  }
}

extension Validator {

  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int> {
  ///   Validator.accumulating {
  ///     Validator.fail()
  ///     Int.equals(1)
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
    .init(Validations.Validators.FailingValidator<Self>())
  }
}

extension AsyncValidator {

  /// A validation that never succeeds.  This is useful for some testing purposes.
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = AsyncValidatorOf<Int> {
  ///   AsyncValidator.accumulating {
  ///     AsyncValidator.fail()
  ///     Int.equals(1).async
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
    .init(Validator.fail().async())
  }
}
