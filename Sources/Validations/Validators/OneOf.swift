extension Validator {
  /// Ensures one of the validators succeds to validate a value.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Validators.OneOf {
  ///     Int.equals(1)
  ///     Int.equals(2)
  ///   }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  public static func oneOf<V: Validation>(
    @OneOfBuilder<Value> builder: () -> V
  ) -> Self
  where V.Value == Value {
    .init(builder())
  }
}

extension AsyncValidator {
  /// Ensures one of the validators succeds to validate a value.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Validators.OneOf {
  ///     Int.equals(1)
  ///     Int.equals(2)
  ///   }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  public static func oneOf<V: AsyncValidation>(
    @OneOfBuilder<Value> builder: () -> V
  ) -> Self
  where V.Value == Value {
    .init(builder())
  }
}
