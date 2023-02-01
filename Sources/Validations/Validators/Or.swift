extension Validators {
  public struct OrValidator<Value>: Validator {
    
    @usableFromInline
    let lhs: any Validator<Value>
    
    @usableFromInline
    let rhs: any Validator<Value>
    
    @inlinable
    public init(_ lhs: any Validator<Value>, _ rhs: any Validator<Value>) {
      self.lhs = lhs
      self.rhs = rhs
    }
    
    public var body: some Validator<Value> {
      OneOf {
        lhs.eraseToAnyValidator()
        rhs.eraseToAnyValidator()
      }
    }
    
    @inlinable
    public func validate(_ value: Value) throws {
      do {
        try self.body.validate(value)
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
  ///   - other: The other validator to use.
  public func or(_ other: some Validator<Self.Value>) -> some Validator<Value> {
    Validators.OrValidator(self, other)
  }

  /// Succeeds if one of the validators passes.
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
  public func or(@ValidationBuilder<Self.Value> _ build: () -> some Validator<Self.Value>)
    -> some Validator<Value>
  {
    Validators.OrValidator(self, build())
  }
  
  public func or(_ validation: Validation<Value>) -> some Validator<Self.Value> {
    Validators.OrValidator(self, validation)
  }
}
