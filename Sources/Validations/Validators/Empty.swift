
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
public struct Empty<Value: Collection>: Validator {

  public init() {}

  public var body: some Validator<Value> {
    Validate(\.isEmpty, using: .true())
  }
}

extension Validation where Value: Collection {
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
  public static func empty() -> some Validator<Self> {
    Validators.Empty()
  }
}
