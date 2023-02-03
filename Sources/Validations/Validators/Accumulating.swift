extension Validators {
  /// A  validation that accumulates errors for the child validators upon validation failures.
  ///
  /// This type only accumulates errors for the top-level items that are passed into the build context.
  /// If your validators are deeply nested, the nested childern may / may not accumulate errors depending
  /// on how they are created.
  ///
  /// > Note: This type is generally not interacted with directly, instead use one of the global functions
  /// > ``Accumulating(_:)-1hiwq`` or one of the static methods on the concrete validators, such as
  /// > ``Validator/accumulating(accumulating:)``.
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
  ///         Accumulating { // accumulate errors for the email child validator.
  ///           NotEmpty()
  ///           Contains("@")
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
  public struct Accumulating<Value, Validators> {

    public let validators: Validators

    @inlinable
    init(_ validators: Validators) {
      self.validators = validators
    }
  }
}

extension Validators.Accumulating: Validation
where
  Validators: Validation,
  Validators.Value == Value
{
  /// Create an accumulating validation using the ``AccumulatingErrorBuilder`` builder syntax.
  ///
  /// - Parameters:
  ///   - validators: The validations to accumulate errors for during validations.
  @inlinable
  public init(
    @AccumulatingErrorBuilder<Value> validators: () -> Validators
  ) {
    self.init(validators())
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try self.validators.validate(value)
  }
}

extension Validators.Accumulating: AsyncValidation
where
  Validators: AsyncValidation,
  Validators.Value == Value
{
  /// Create an accumulating validation using the ``AccumulatingErrorBuilder`` builder syntax.
  ///
  /// - Parameters:
  ///   - validators: The validations to accumulate errors for during validations.
  @inlinable
  public init(
    @AccumulatingErrorBuilder<Value> validators: () -> Validators
  ) {
    self.init(validators())
  }

  @inlinable
  public func validate(_ value: Value) async throws {
    try await self.validators.validate(value)
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
  ///     Accumulating {
  ///       Validate(\.name, using: .notEmpty())
  ///       Validate(\.email, using: .accumulating {
  ///            NotEmpty()
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

/// A  ``Validation`` that accumulates errors for the child validators upon validation failures.
///
/// This type only accumulates errors for the top-level items that are passed into the build context.
/// If your validators are deeply nested, the nested childern may / may not accumulate errors depending
/// on how they are created.
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
///         Accumulating { // accumulate errors for the email child validator.
///           NotEmpty()
///           Contains("@")
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
public func Accumulating<Value, Validators: Validation>(
  @AccumulatingErrorBuilder<Value> _ builder: () -> Validators
) -> Validations.Validators.Accumulating<Value, Validators>
where Validators.Value == Value {
  .init(builder())
}

/// An ``AsyncValidation`` that accumulates errors for the child validators upon validation failures.
///
/// This type only accumulates errors for the top-level items that are passed into the build context.
/// If your validators are deeply nested, the nested childern may / may not accumulate errors depending
/// on how they are created.
///
///  ** Example**
///```swift
/// struct User: AsyncValidatable {
///
///   let name: String
///   let email: String
///
///   var body: some AsyncValidator<Self> {
///     Accumulating {
///       Validate(\.name, using: NotEmpty()).async
///       Validate(\.email) {
///         Accumulating { // accumulate errors for the email child validator.
///           NotEmpty()
///           Contains("@")
///         }
///       }.async
///     }
///   }
/// }
///
/// try User(name: "blob", email: "blob@example.com").validate() // succeeds.
/// try User(name: "", email: "") // fails with 3 errors.
/// ```
///
public func Accumulating<Value, Validators: AsyncValidation>(
  @AccumulatingErrorBuilder<Value> _ builder: () -> Validators
) -> Validations.Validators.Accumulating<Value, Validators>
where Validators.Value == Value {
  .init(builder())
}
