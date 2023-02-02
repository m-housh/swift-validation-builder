
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
    Validate(\.isEmpty, using: .true())
  }
}

extension Validator where Value: Collection {
  /// Validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = ValidatorOf<String>.empty()
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  public static func empty() -> Self {
    self.init(Empty())
  }
}

extension Validators {
  public typealias Empty = Validations.Empty
}

extension Collection {
  
  @inlinable
  public static func empty() -> some Validation<Self> {
    Validators.Empty()
  }
}
