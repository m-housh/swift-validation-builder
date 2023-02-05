extension Validators {
  /// Inverses a validator.
  ///
  /// **Example**
  /// ```swift
  /// let noOnes = ValidatorOf<Int> {
  ///   Validators.Not(Int.equals(1))
  /// }
  ///
  /// try noOnes.validate(0) // success.
  /// try noOnes.validate(1) // fails.
  ///
  /// ```
  public struct Not<Validations> {

    @usableFromInline
    let validations: Validations

    /// Create a not validator from an existing validator.
    ///
    /// **Example**
    /// ```swift
    /// let blobValidator = ValidatorOf<String> {
    ///   String.equals("blob")
    /// }
    ///
    /// let notBlobValidator = Validators.Not(blobValidator)
    ///
    /// try notBlobValidator.validate("blob jr.") // success.
    /// try notBlobValidator.validate("blob") // fails
    /// ```
    ///
    @inlinable
    public init(_ validations: Validations) {
      self.validations = validations
    }

  }
}

extension Validators.Not: Validation where Validations: Validation {
  @inlinable
  public func validate(_ value: Validations.Value) throws {
    do {
      // should throw an error.
      try self.validations.validate(value)
    } catch {
      // happy path.
      return
    }
    throw ValidationError.failed(summary: "Not validator did not succeed.")
  }
}

extension Validators.Not: AsyncValidation where Validations: AsyncValidation {
  @inlinable
  public func validate(_ value: Validations.Value) async throws {
    do {
      // should throw an error.
      try await self.validations.validate(value)
    } catch {
      // happy path.
      return
    }
    throw ValidationError.failed(summary: "Not validator did not succeed.")
  }
}

extension Validator {

  @inlinable
  public static func not(
    @ValidationBuilder<Value> with build: () -> some Validation<Value>
  ) -> Self {
    .init(Validators.Not(build()))
  }

  @inlinable
  public static func not(_ validation: some Validation<Value>) -> Self {
    .init(Validators.Not(validation))
  }

  @inlinable
  public static func not(_ validation: Self) -> Self {
    .init(Validators.Not(validation))
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
  //    @inlinable
  //    public init(@ValidationBuilder<Validate.Value> _ build: () -> Validate) {
  //      self.init(build())
  //    }

}
