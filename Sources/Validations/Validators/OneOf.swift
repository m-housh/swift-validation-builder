extension Validators {
  /// Ensures one of the validators succeds to validate a value.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Validators.OneOf {
  ///     Int.equals(1)
  ///     Int.equals(2)
  ///   }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  public struct OneOfValidator<Value, Validators> {

    public let validators: Validators

    /// Create a ``OneOf`` validator.
    ///
    /// This method is internal, because it does not make sense to call outside of the builder context.
    ///
    @inlinable
    init(_ validator: Validators) {
      self.validators = validator
    }
  }
}

extension Validators.OneOfValidator: Validation where Validators: Validation, Validators.Value == Value {

  /// Create a ``OneOf`` validator using builder syntax.
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   OneOf {
  ///     Equals(1)
  ///     Equals(2)
  ///   }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails
  /// ```
  ///
  //  @inlinable
  //  public init(
  //    @OneOfBuilder<Value> builder: @escaping () -> Validators
  //  ) {
  //    self.validators = builder()
  //    self.init(builder())
  //  }

  @inlinable
  public func validate(_ value: Validators.Value) throws {
    try validators.validate(value)
  }
}

extension Validators.OneOfValidator: AsyncValidation
where Validators: AsyncValidation, Validators.Value == Value {

  @inlinable
  public func validate(_ value: Value) async throws {
    try await validators.validate(value)
  }
}

extension Validator {

  public static func oneOf<V: Validation>(
    @OneOfBuilder<Value> builder: () -> V
  ) -> Self
  where V.Value == Value {
    .init(builder())
  }
}

extension AsyncValidator {

  public static func oneOf<V: AsyncValidation>(
    @OneOfBuilder<Value> builder: () -> V
  ) -> Self
  where V.Value == Value {
    .init(builder())
  }
}

extension Validators {
  
  public static func OneOf<Value, Validators: Validation>(
    @OneOfBuilder<Value> builder: () -> Validators
  ) -> Validations.Validators.OneOfValidator<Value, Validators> {
    .init(builder())
  }
  
  public static func OneOf<Value, Validators: AsyncValidation>(
    @OneOfBuilder<Value> builder: () -> Validators
  ) -> Validations.Validators.OneOfValidator<Value, Validators> {
    .init(builder())
  }
}
