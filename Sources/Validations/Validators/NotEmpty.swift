extension Validators {
  /// A validator that validates a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = ValidatorOf<String> {
  ///   Validators.NotEmpty()
  /// }
  ///
  /// try notEmptyString.validate("foo") // success.
  /// try notEmptyString.validate("") //fails.
  /// ```
  ///
  public struct NotEmptyValidator<ValidationType, Value: Collection> {

    public init() {}

  }
}

extension Validators.NotEmptyValidator: Validation where ValidationType: Validation {
  
  public var body: some Validation<Value> {
    Validator.not(.empty())
      .mapError(ValidationError.failed(summary: "Expected to not be empty."))
  }
}

extension Validators.NotEmptyValidator: AsyncValidation where ValidationType: AsyncValidation {
  
  public var body: some AsyncValidation<Value> {
    Validator.notEmpty()
      .async()
      .mapError(ValidationError.failed(summary: "Expected to not be empty."))
  }
}

extension Validator where Value: Collection {

  /// Validaties a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = ValidatorOf<String>.notEmpty()
  ///
  /// try notEmptyString.validate("blob") // succeeds.
  /// try notEmptyString.validate("") // fails.
  /// ```
  ///
  /// > Note: The `notEmpty()` method is also available from the `Collection` type, so
  /// > the above could be written as `let notEmptyString = String.notEmpty()`
  ///
  @inlinable
  public static func notEmpty() -> Self {
    .init(Validators.NotEmptyValidator<Self, Value>())
  }
}

extension AsyncValidator where Value: Collection {

  /// Validaties a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = AsyncValidatorOf<String>.notEmpty()
  ///
  /// try await notEmptyString.validate("blob") // succeeds.
  /// try await notEmptyString.validate("") // fails.
  /// ```
  ///
  /// > Note: The `notEmpty()` method is also available from the `Collection` type, so
  /// > the above could be written as `let notEmptyString = String.notEmpty().async()`
  ///
  @inlinable
  public static func notEmpty() -> Self {
    .init(Validator.notEmpty())
  }
}

extension Collection {

  /// Validaties a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = String.notEmpty()
  ///
  /// try notEmptyString.validate("blob") // succeeds.
  /// try notEmptyString.validate("") // fails.
  /// ```
  ///
  @inlinable
  public static func notEmpty() -> Validator<Self> {
    .notEmpty()
  }
}
