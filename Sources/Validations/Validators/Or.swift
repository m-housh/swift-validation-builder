extension Validators {
  /// A ``Validation`` that succeeds if either of the underlying validators succeed.
  ///
  /// This type is generally not interacted with directly, instead use one of the ``Validation/or(_:)-97ygx``
  /// or ``AsyncValidation/or(_:)-7jj5l``methods on an existing validation.
  ///
  ///
  public struct OrValidator<LhsValidator, RhsValidator> {
    @usableFromInline
    let lhs: LhsValidator

    @usableFromInline
    let rhs: RhsValidator

    @inlinable
    public init(
      _ lhs: LhsValidator,
      _ rhs: RhsValidator
    ) {
      self.lhs = lhs
      self.rhs = rhs
    }
  }
}

extension Validators.OrValidator: Validation
where
  LhsValidator: Validation,
  RhsValidator: Validation,
  LhsValidator.Value == RhsValidator.Value
{

  fileprivate var validator: some Validation<LhsValidator.Value> {
    OneOf {
      lhs
      rhs
    }
    .mapError(ValidationError.failed(summary: "Did not pass any 'or' validations."))
  }

  public func validate(_ value: LhsValidator.Value) throws {
    try validator.validate(value)
  }

}

extension Validators.OrValidator: AsyncValidation
where
  LhsValidator: AsyncValidation,
  RhsValidator: AsyncValidation,
  LhsValidator.Value == RhsValidator.Value
{

  var asyncValidator: some AsyncValidation<LhsValidator.Value> {
    OneOf {
      lhs
      rhs
    }
    .mapError(ValidationError.failed(summary: "Did not pass any 'or' validations."))
  }

  public func validate(_ value: LhsValidator.Value) async throws {
    try await asyncValidator.validate(value)
  }
}

extension Validation {

  /// Create a ``Validation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Equals(1)
  ///     .or(Equals(2))
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other validator to use.
  public func or<Downstream: Validation>(
    _ validation: Downstream
  ) -> Validators.OrValidator<Self, Downstream>
  where Downstream.Value == Self.Value {
    Validators.OrValidator(self, validation)
  }

  /// Create a ``Validation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Equals(1)
  ///     .or {
  ///       Equals(2)
  ///      }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - build: The other validator to use.
  public func or<Downstream: Validation>(
    @ValidationBuilder<Self.Value> _ build: () -> Downstream
  ) -> Validators.OrValidator<Self, Downstream>
  where Downstream.Value == Self.Value {
    Validators.OrValidator(self, build())
  }

  /// Create a ``Validation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Equals(1)
  ///     .or {
  ///       Equals(2)
  ///      }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other ``Validator`` to use.
  public func or(_ validation: Validator<Value>) -> Validators.OrValidator<Self, Validator<Value>> {
    Validators.OrValidator(self, validation)
  }
}

extension AsyncValidation {

  /// Create an``AsyncValidation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Equals(1)
  ///     .or(Equals(2))
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other validator to use.
  public func or<Downstream: AsyncValidation>(
    _ validation: Downstream
  ) -> Validators.OrValidator<Self, Downstream>
  where Downstream.Value == Self.Value {
    Validators.OrValidator(self, validation)
  }

  /// Create an``AsyncValidation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Equals(1)
  ///     .or {
  ///       Equals(2)
  ///      }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - build: The other validator to use.
  public func or<Downstream: AsyncValidation>(
    @ValidationBuilder<Self.Value> _ build: () -> Downstream
  ) -> Validators.OrValidator<Self, Downstream>
  where Downstream.Value == Self.Value {
    Validators.OrValidator(self, build())
  }

  /// Create an ``AsyncValidation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Equals(1)
  ///     .or {
  ///       Equals(2)
  ///      }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other ``Validator`` to use.
  public func or(_ validation: AsyncValidator<Value>) -> Validators.OrValidator<Self, AsyncValidator<Value>> {
    Validators.OrValidator(self, validation)
  }
}

