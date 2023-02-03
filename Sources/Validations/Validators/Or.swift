extension Validators {
  /// A ``Validation`` that succeeds if either of the underlying validators succeed.
  ///
  /// This type is generally not interacted with directly, install use one of the ``Validation/or(_:)-97ygx``
  /// methods on an existing validation.
  ///
  ///
  public struct OrValidator<Value>: Validation {
    
    @usableFromInline
    let lhs: any Validation<Value>
    
    @usableFromInline
    let rhs: any Validation<Value>
    
    @inlinable
    public init(
      _ lhs: any Validation<Value>,
      _ rhs: any Validation<Value>
    ) {
      self.lhs = lhs
      self.rhs = rhs
    }
    
    public var body: some Validation<Value> {
      OneOf {
        lhs.eraseToAnyValidator()
        rhs.eraseToAnyValidator()
      }
      .mapError(ValidationError.failed(summary: "Did not pass any 'or' validations."))
    }
  }
}

extension Validation {

  /// Create a ``Validator`` that succeeds if one of the validators passes.
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
  public func or(_ validation: some Validation<Self.Value>) -> some Validation<Value> {
    Validators.OrValidator(self, validation)
  }

  /// Create a ``Validator`` that succeeds if one of the validators passes.
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
  
  /// Create a ``Validator`` that succeeds if one of the validators passes.
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
  public func or(_ validation: Validator<Value>) -> some Validation<Self.Value> {
    Validators.OrValidator(self, validation)
  }
}
