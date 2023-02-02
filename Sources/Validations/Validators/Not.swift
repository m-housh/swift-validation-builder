extension Validators {
  /// Inverses a validator.
  ///
  /// **Example**
  /// ```swift
  /// let noOnes = ValidatorOf<Int> {
  ///   Not(Equals(1))
  /// }
  ///
  /// try noOnes.validate(0) // success.
  /// try noOnes.validate(1) // fails.
  ///
  /// ```
  public struct Not<Validate: Validation>: Validation {
    
    @usableFromInline
    let validator: Validate
    
    /// Create a not validator from an existing validator.
    ///
    /// **Example**
    /// ```swift
    /// let blobValidator = ValidatorOf<String> {
    ///   Equals("blob")
    /// }
    ///
    /// let notBlobValidator = Not(blobValidator)
    ///
    /// try notBlobValidator.validate("blob jr.") // success.
    /// try notBlobValidator.validate("blob") // fails
    /// ```
    ///
    @inlinable
    public init(_ validator: Validate) {
      self.validator = validator
    }
    
    @inlinable
    public init<Value>(_ validation: Validator<Value>) where Validate == Validator<Value> {
      self.init(validation)
    }
    
    /// Create a not validator using builder syntax.
    ///
    /// **Example**
    /// ```swift
    /// let blobValidator = ValidatorOf<String> {
    ///   Equals("blob")
    /// }
    ///
    /// let notBlobValidator = Not {
    ///   blobValidator
    /// }
    ///
    /// try notBlobValidator.validate("blob jr.") // success.
    /// try notBlobValidator.validate("blob") // fails
    /// ```
    ///
    @inlinable
    public init(@ValidationBuilder<Validate.Value> _ build: () -> Validate) {
      self.init(build())
    }
    
    @inlinable
    public func validate(_ value: Validate.Value) throws {
      do {
        // should throw an error.
        try self.validator.validate(value)
      } catch {
        // happy path.
        return
      }
      throw ValidationError.failed(summary: "Not validator did not succeed.")
    }
  }
}

extension Validator {
  
  public static func not(
    @ValidationBuilder<Value> with build: () -> some Validation<Value>
  ) -> Self {
    .init(Validators.Not(build()))
  }
}

public typealias Not = Validators.Not
