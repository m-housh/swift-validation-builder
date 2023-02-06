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
  )
    -> some Validation<Value>
  where Downstream.Value == Self.Value {
    Validator.oneOf {
      self
      validation
    }
    //    Validators.OrValidator(self, validation)
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
  )
    -> some Validation<Value>
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
  public func or(
    _ validation: Validator<Value>
  )
    -> some Validation<Value>
  {
    Validator.oneOf {
      self
      validation
    }
  }
}

// MARK: - Async
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
  )
    -> some AsyncValidation<Value>
  where Downstream.Value == Self.Value {
    AsyncValidator.oneOf {
      self
      validation
    }
  }

  /// Create an``AsyncValidation`` that succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```swift
  /// let oneOrTwo = AsyncValidatorOf<Int> {
  ///   AsyncValidator.equals(1).or(.equals(2))
  /// }
  ///
  /// try await oneOrTwo.validate(1) // success.
  /// try await oneOrTwo.validate(2) // success.
  /// try await oneOrTwo.validate(3) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - validation: The other validator to use.
  public func or(
    _ validation: AsyncValidator<Value>
  )
    -> some AsyncValidation<Value>
  {
    AsyncValidator.oneOf {
      self
      validation
    }
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
  )
    -> some AsyncValidation<Value>
  where Downstream.Value == Self.Value {
    self.or(build())
  }

}
