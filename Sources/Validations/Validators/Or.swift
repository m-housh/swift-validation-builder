struct _Or<Validate: Validator>: Validator {

  @usableFromInline
  let lhs: Validate

  @usableFromInline
  let rhs: any Validator<Value>

  @inlinable
  public init(_ lhs: Validate, _ rhs: some Validator<Value>) {
    self.lhs = lhs
    self.rhs = rhs
  }

  @inlinable
  public func validate(_ value: Validate.Value) throws {
    do {
      try lhs.validate(value)
    } catch {
      do {
        try rhs.validate(value)
      } catch {
        throw ValidationError.failed(summary: "Did not pass any of the validations.")
      }
    }
  }
}

extension Validator {

  /// Succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```
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
  ///   - other: The other validator to use.
  public func or(_ other: some Validator<Self.Value>) -> some Validator<Value> {
    _Or(self, other)
  }

  /// Succeeds if one of the validators passes.
  ///
  /// **Example**
  /// ```
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
  public func or(@ValidationBuilder<Self.Value> _ build: () -> some Validator<Self.Value>)
    -> some Validator<Value>
  {
    _Or(self, build())
  }
}
