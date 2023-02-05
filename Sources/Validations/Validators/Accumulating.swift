extension Validators {
  /// A  validation that accumulates errors for the child validators upon validation failures.
  ///
  /// This type only accumulates errors for the top-level items that are passed into the build context.
  /// If your validators are deeply nested, the nested childern may / may not accumulate errors depending
  /// on how they are created.
  ///
  /// > Note: This type is generally not interacted with directly, instead use one of the static methods like
  /// >   one of the static methods on the concrete validators, such as ``Validator/accumulating(accumulating:)``.
  ///
  ///  ** Example**
  ///```swift
  /// struct User: Validatable {
  ///
  ///   let name: String
  ///   let email: String
  ///
  ///   var body: some Validator<Self> {
  ///     Validator.accumulating {
  ///       Validator.validate(\.name, using: String.notEmpty())
  ///       Validator.validate(\.email) {
  ///         Validator.accumulating { // accumulate errors for the email child validator.
  ///           String.notEmpty()
  ///           String.contains("@")
  ///         }
  ///       }
  ///     }
  ///   }
  /// }
  ///
  /// try User(name: "blob", email: "blob@example.com").validate() // succeeds.
  /// try User(name: "", email: "") // fails with 3 errors.
  /// ```
  ///
  public struct AccumulatingValidator<Value, Validators> {

    public let validators: Validators

    @inlinable
    init(_ validators: Validators) {
      self.validators = validators
    }
  }
}

extension Validator {

  /// Create a ``Validator`` instance accumulating errors of the child validations.
  ///
  /// This is a convenience when building nested validations with types that can also
  /// work with the concrete ``Validator`` type.
  ///
  /// ```swift
  /// struct User: Validatable {
  ///
  ///   let name: String
  ///   let email: String
  ///
  ///   var body: some Validation<Self> {
  ///     Validator.accumulating {
  ///       Validator.validate(\.name, with: .notEmpty())
  ///       Validator.validate(\.email, with: .accumulating {
  ///            String.notEmpty()
  ///           String.contains("@")
  ///       })
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - accumulating: The validation to accumulate errors for.
  ///
  @inlinable
  public static func accumulating(
    @AccumulatingErrorBuilder<Value> accumulating: () -> some Validation<Value>
  ) -> Self {
    .init(accumulating())
  }
}

extension AsyncValidator {

  /// Create an ``AsyncValidator`` instance accumulating errors of the child validations.
  ///
  /// This is a convenience when building nested validations with types that can also
  /// work with the concrete ``AsyncValidator`` type.
  ///
  /// ```swift
  /// struct User: AsyncValidatable {
  ///
  ///   let name: String
  ///   let email: String
  ///
  ///   var body: some AsyncValidation<Self> {
  ///     AsyncValidator.accumulating {
  ///       AsyncValidator.validate(\.name, using: .notEmpty())
  ///       AsyncValidator.validate(\.email, using: .accumulating {
  ///           String.notEmpty().async
  ///           String.contains("@").async
  ///       })
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - accumulating: The validation to accumulate errors for.
  ///
  @inlinable
  public static func accumulating(
    @AccumulatingErrorBuilder<Value> accumulating: () -> some AsyncValidation<Value>
  ) -> Self {
    .init(accumulating())
  }
}

extension Validators.AccumulatingValidator: Validation
where
  Validators: Validation,
  Validators.Value == Value
{

  @inlinable
  public func validate(_ value: Value) throws {
    try self.validators.validate(value)
  }
}

extension Validators.AccumulatingValidator: AsyncValidation
where
  Validators: AsyncValidation,
  Validators.Value == Value
{
  
  @inlinable
  public func validate(_ value: Value) async throws {
    try await self.validators.validate(value)
  }
}

