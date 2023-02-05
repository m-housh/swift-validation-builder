extension Validators {
  /// A  validation that accumulates errors for the child validators upon validation failures.
  ///
  /// This type only accumulates errors for the top-level items that are passed into the build context.
  /// If your validators are deeply nested, the nested childern may / may not accumulate errors depending
  /// on how they are created.
  ///
  /// > Note: This type is generally not interacted with directly, instead use one of the static methods like
  /// > ``Validators/Accumulating(_:)-6qcyf`` or one of the static methods on the concrete validators, such as
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
  ///     Validators.Accumulating {
  ///       Validators.validate(\.name, using: NotEmpty())
  ///       Validators.validate(\.email) {
  ///         Validators.Accumulating { // accumulate errors for the email child validator.
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
  public struct AccumulatingValidator<Value, Validators> {

    public let validators: Validators

    @inlinable
    init(_ validators: Validators) {
      self.validators = validators
    }
  }
}

extension Validators.AccumulatingValidator: Validation
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

extension Validators.AccumulatingValidator: AsyncValidation
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
  ///     Validator.accumulating {
  ///       Validators.validate(\.name, using: .notEmpty())
  ///       validate(\.email, using: .accumulating {
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
  ///       Validators.validate(\.name, using: .notEmpty())
  ///       validate(\.email, using: .accumulating {
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
    @AccumulatingErrorBuilder<Value> accumulating: () -> some AsyncValidation<Value>
  ) -> Self {
    .init(accumulating())
  }
}

extension Validators {
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
  ///     Validators.accumulating {
  ///       validate(\.name, with: String.notEmpty())
  ///       validate(\.email) {
  ///         Validators.accumulating { // accumulate errors for the email child validator.
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
  //  public static func accumulating<Value, Validators: Validation>(
  //    @AccumulatingErrorBuilder<Value> _ builder: () -> Validators
  //  ) -> Validations.Validators.AccumulatingValidator<Value, Validators>
  //  where Validators.Value == Value {
  //    .init(builder())
  //  }

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
  ///     Validators.accumulating {
  ///       validate(\.name, with: String.notEmpty()).async
  ///       validate(\.email) {
  ///         Validators.accumulating { // accumulate errors for the email child validator.
  ///           String.notEmpty()
  ///           String.contains("@")
  ///         }.async
  ///       }
  ///     }
  ///   }
  /// }
  ///
  /// try User(name: "blob", email: "blob@example.com").validate() // succeeds.
  /// try User(name: "", email: "") // fails with 3 errors.
  /// ```
  ///
  //  public static func accumulating<Value, Validators: AsyncValidation>(
  //    @AccumulatingErrorBuilder<Value> _ builder: () -> Validators
  //  ) -> Validations.Validators.AccumulatingValidator<Value, Validators>
  //  where Validators.Value == Value {
  //    .init(builder())
  //  }
}
