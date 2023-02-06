extension Validator where Value: Collection {
  /// Create a ``Validator`` that validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = ValidatorOf<String>.empty()
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  ///
  /// > Note; The above can be accessed from the collection type directly as well, so the above validation could be
  /// > written as `let emptyValidator = String.empty()`
  ///
  public static func empty() -> Self {
    self.init(Validators.EmptyValidator<Self, Value>())
  }
}

extension AsyncValidator where Value: Collection {
  /// Create a ``Validator`` that validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = ValidatorOf<String>.empty()
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  ///
  /// > Note; The above can be accessed from the collection type directly as well, so the above validation could be
  /// > written as `let emptyValidator = String.empty()`
  ///
  public static func empty() -> Self {
    self.init(Validators.EmptyValidator<Self, Value>())
  }
}

extension Validators {
  /// Validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = ValidatorOf<String> {
  ///    String.empty()
  ///  }
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  public struct EmptyValidator<ValidationType, Value: Collection> {

    public init() {}

  }
}

extension Validators.EmptyValidator: Validation where ValidationType: Validation {

  public var body: some Validation<Value> {
    Validator.validate(\.isEmpty, with: true)
      .mapError(ValidationError.failed(summary: "Expected to be empty."))
  }
}

extension Validators.EmptyValidator: AsyncValidation where ValidationType: AsyncValidation {

  public var body: some AsyncValidation<Value> {
    Validator.empty().async()
  }
}
