/// Inverses a validator.
///
/// **Example**
/// ```
/// let noOnes = ValidatorOf<Int> {
///   Not(Equals(1))
/// }
///
/// try noOnes.validate(0) // success.
/// try noOnes.validate(1) // fails.
///
/// ```
public struct Not<Validate: Validator>: Validator {

  @usableFromInline
  let validator: Validate

  /// Create a not validator from an existing validator.
  ///
  /// **Example**
  /// ```
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

  /// Create a not validator using builder syntax.
  ///
  /// **Example**
  /// ```
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
    self.validator = build()
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
    throw ValidationError(message: "Not validator did not succeed.")
  }
}
