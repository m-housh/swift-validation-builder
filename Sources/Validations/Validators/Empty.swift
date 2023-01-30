/// Validates a collection is empty.
///
/// ```
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
    Equals(\.isEmpty, true)
  }
}
