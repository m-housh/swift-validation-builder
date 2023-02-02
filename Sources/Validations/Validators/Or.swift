extension Validators {
  public struct OrValidator<Value>: Validation {
    
    @usableFromInline
    let lhs: any Validation<Value>
    
    @usableFromInline
    let rhs: any Validation<Value>
    
    @inlinable
    public init(_ lhs: any Validation<Value>, _ rhs: any Validation<Value>) {
      self.lhs = lhs
      self.rhs = rhs
    }
    
    public var body: some Validation<Value> {
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

extension Validation {

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
  public func or(_ other: some Validation<Self.Value>) -> some Validation<Value> {
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
  public func or(@ValidationBuilder<Self.Value> _ build: () -> some Validation<Self.Value>)
    -> some Validation<Value>
  {
    Validators.OrValidator(self, build())
  }
  
  public func or(_ validation: Validator<Value>) -> some Validation<Self.Value> {
    Validators.OrValidator(self, validation)
  }
}
