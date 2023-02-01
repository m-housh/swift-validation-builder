/// A validator that accumulates errors for the child validators.
///
///  ** Example**
///```swift
/// struct User: Validatable {
///
///   let name: String
///   let email: String
///
///   var body: some Validator<Self> {
///     Accumulating {
///       Validate(\.name, using: NotEmpty())
///       Validate(\.email) {
///         Accumulating {
///           NotEmpty()
///           Contains("@")
///         }
///       }
///     }
///   }
/// }
/// ```
// TODO: switch to being generic over the validator, so it can be an async validator too.
public struct Accumulating<Value>: Validator {

  public let validators: any Validator<Value>
  
  @inlinable
  public init<V: Validator>(_ validators: V) where V.Value == Value {
    self.validators = validators
  }

  @inlinable
  public init(
    @AccumulatingErrorBuilder<Value> builder: () -> some Validator<Value>
  ) {
    self.validators = builder()
  }

  public func validate(_ value: Value) throws {
    try self.validators.validate(value)
  }
}

