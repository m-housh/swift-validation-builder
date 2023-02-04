extension Validation {
  
  /// Add a label to the error(s) for this ``Validation``.
  ///
  /// **Example**
  /// ```swift
  /// let validator = Int.greaterThan(0).errorLabel("My Int", inline: true)
  ///
  /// try validator.validate(-1) // fails
  /// // error = "My Int: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  public func errorLabel(_ label: String, inline: Bool = false) -> Validators.ErrorLabelValidator<Self> {
    .init(label: label, inlineLabel: inline, validator: self)
  }
  
}

extension AsyncValidation {
  /// Add a label to the error(s) for this ``AsyncValidation``.
  ///
  /// **Example**
  /// ```swift
  /// let validator = Int.greaterThan(0).async.errorLabel("My Int", inline: true)
  ///
  /// try await validator.validate(-1) // fails
  /// // error = "My Int: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  public func errorLabel(_ label: String, inline: Bool = false) -> Validators.ErrorLabelValidator<Self> {
    .init(label: label, inlineLabel: inline, validator: self)
  }
  
}

extension Validators {
  
  /// A validation that add's a label to errors that are thrown.
  ///
  /// This is generally not interacted with directly, instead you use ``Validation/errorLabel(_:inline:)`` method on
  /// a ``Validation`` or ``AsyncValidation``.
  ///
  /// **Example**
  /// ```swift
  /// let validator = Int.greaterThan(0).errorLabel("My Int", inline: true)
  ///
  /// try validator.validate(-1) // fails
  /// // error = "My Int: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  ///
  public struct ErrorLabelValidator<Validator> {
    
    public let label: String
    public let inlineLabel: Bool
    public let validator: Validator
    
    @inlinable
    public init(
      label: String,
      inlineLabel: Bool,
      validator: Validator
    ) {
      self.label = label
      self.inlineLabel = inlineLabel
      self.validator = validator
    }
  }
}

extension Validators.ErrorLabelValidator: Validation where Validator: Validation {
  
  @inlinable
  public func validate(_ value: Validator.Value) throws {
    do {
      try self.validator.validate(value)
    } catch {
      throw ValidationError.failed(label: label, error: error, inlineLabel: inlineLabel)
    }
  }
}

extension Validators.ErrorLabelValidator: AsyncValidation where Validator: AsyncValidation {
  
  @inlinable
  public func validate(_ value: Validator.Value) async throws {
    do {
      try await self.validator.validate(value)
    } catch {
      throw ValidationError.failed(label: label, error: error)
    }
  }
}
