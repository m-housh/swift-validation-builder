extension Validators {
  /// A ``Validation`` that succeeds if either of the underlying validators succeed.
  ///
  /// This type is generally not interacted with directly, instead use the ``Validation/or(_:)-7e8zk``
  /// method on a ``Validation`` or the equivalent on an ``AsyncValidation``.
  ///
  /// ```swift
  /// let validator = Int.greaterThan(10).or(.lessThan(5))
  ///
  /// try validator.validate(11) // success.
  /// try validator.validate(9) // fails.
  ///
  /// ```
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

  @usableFromInline
  var validator: some Validation<LhsValidator.Value> {
    Validators.oneOf {
      lhs
      rhs
    }
    .mapError(ValidationError.failed(summary: "Did not pass any 'or' validations."))
  }

  @inlinable
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

  @usableFromInline
  var asyncValidator: some AsyncValidation<LhsValidator.Value> {
    Validators.oneOf {
      lhs
      rhs
    }
    .mapError(ValidationError.failed(summary: "Did not pass any 'or' validations."))
  }

  @inlinable
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
  ///   Int.equals(1).or(myIntValidation)
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
  ///   Int.equals(1).or {
  ///     Int.equals(2)
  ///   }
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
    self.or(build())
  }

  /// Create a ``Validation`` that succeeds if one of the validators passes.
  ///
  /// This convenience overload allows using static methods on ``Validator``  in order to create the
  /// downstream validation, so that it can look a little cleaner at the call site.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   Int.equals(1).or(.equals(2))
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
  /// let oneOrTwo = AsyncValidatorOf<Int> {
  ///   Int.equals(1).async
  ///     .or(Int.equals(2).async)
  /// }
  ///
  /// try await oneOrTwo.validate(1) // success.
  /// try await oneOrTwo.validate(2) // success.
  /// try await oneOrTwo.validate(3) // fails.
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
  /// let oneOrTwo = AsyncValidatorOf<Int> {
  ///   Int.equals(1).async.or {
  ///     Int.equals(2).async
  ///   }
  /// }
  ///
  ///
  /// try await oneOrTwo.validate(1) // success.
  /// try await oneOrTwo.validate(2) // success.
  /// try await oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - build: The other validator to use.
  public func or<Downstream: AsyncValidation>(
    @AsyncValidationBuilder<Self.Value> _ build: () -> Downstream
  ) -> Validators.OrValidator<Self, Downstream>
  where Downstream.Value == Self.Value {
    Validators.OrValidator(self, build())
  }

  /// Create an ``AsyncValidation`` that succeeds if one of the validators passes.
  ///
  /// This convenience overload allows using static methods on ``Validator``  in order to create the
  /// downstream validation, so that it can look a little cleaner at the call site.  The synchronous ``Validator`` will
  /// be transformed to an asynchronous one under the hood.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = AsyncValidatorOf<Int> {
  ///   Int.equals(1).async
  ///     .or(.equals(2)) // internally converts to an async validation.
  /// }
  ///
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other ``Validator`` to use.
  public func or(_ validation: Validator<Value>)
    -> Validators.OrValidator<Self, AsyncValidator<Value>>
  {
    self.or(validation.async)
  }

  /// Create an ``AsyncValidation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = AsyncValidatorOf<Int> {
  ///   Int.equals(1).async
  ///     .or(mySynchronousIntValidation) // internally converts to an async validation.
  /// }
  ///
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other ``Validator`` to use.
  public func or(_ validation: any Validation<Value>)
    -> Validators.OrValidator<Self, AsyncValidator<Value>>
  {
    self.or(validation.async)
  }
}
