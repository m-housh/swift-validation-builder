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
public struct Accumulating<Value>: Validator {

  public let validator: any Validator<Value>

  @inlinable
  public init(
    @AccumulatingErrorBuilder<Value> builder: () -> any Validator<Value>
  ) {
    self.validator = builder()
  }

  public func validate(_ value: Value) throws {
    try self.validator.validate(value)
  }
}

//extension Validation {
//
//  public static func accumulating(
//    @AccumulatingErrorBuilder<Value> builder: () -> some Validator<Value>
//  ) -> Self
//  where Validators.Value == Value
//  {
//    .init(builder())
//  }
//}
