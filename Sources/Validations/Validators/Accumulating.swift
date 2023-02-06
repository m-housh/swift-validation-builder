extension Validator {

  /// Create a ``Validator`` instance accumulating errors of the child validations.
  ///
  /// This is a convenient when building nested validations with types that can also
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
