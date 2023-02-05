extension Validators {
  /// Validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = ValidatorOf<String> {
  ///    Empty()
  ///  }
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  public struct Empty<Value: Collection>: Validation {

    public init() {}

    public var body: some Validation<Value> {
      Validator.validate(\.isEmpty, with: true)
        .mapError(ValidationError.failed(summary: "Expected empty."))
    }
  }
}

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
    self.init(Validators.Empty())
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
    self.init(Validator.empty().async)
  }
}
extension Collection {
  /// Validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = String.empty()
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  ///
  @inlinable
  public static func empty() -> Validators.Empty<Self> {
    Validators.Empty()
  }
}
