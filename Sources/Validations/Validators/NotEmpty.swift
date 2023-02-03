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
  public struct NotEmpty<Value: Collection>: Validation {

    public init() {}

    public var body: some Validation<Value> {
      Not(Empty())
        .mapError(ValidationError.failed(summary: "Expected to not be empty."))
    }
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
    .init(Validators.NotEmpty())
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
  public static func notEmpty() -> some Validation<Self> {
    Validators.NotEmpty()
  }
}
