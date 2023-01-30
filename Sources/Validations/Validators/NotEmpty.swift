/// A validator that validates a collection is not empty.
///
/// **Example**
/// ```
/// let notEmptyString = ValidatorOf<String> {
///   NotEmpty()
/// }
///
/// try notEmptyString.validate("foo") // success.
/// try notEmptyString.validate("") //fails.
/// ```
///
public struct NotEmpty<Value: Collection>: Validator {

  public init() {}

  public var body: some Validator<Value> {
    Not(Empty())
  }
}
