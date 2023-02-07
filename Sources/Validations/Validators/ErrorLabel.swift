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
  @inlinable
  public func errorLabel(_ label: String, inline: Bool = false)
    -> Validators.ErrorLabelValidator<Self>
  {
    .init(label: label, inlineLabel: inline, validator: self)
  }

  /// Add a label to the error(s) for this ``Validation``.
  ///
  /// **Example**
  /// ```swift
  /// enum MyErrorLabels: CustomStringConvertible {
  ///   case myInt
  ///   case myString
  ///
  ///   var description: String {
  ///     switch self {
  ///       case .myInt: return "My Int"
  ///       case .myString: return "My String"
  ///     }
  ///   }
  /// }
  ///
  /// let validator = Int.greaterThan(0).errorLabel(MyErrorLabels.myInt, inline: true)
  ///
  /// try validator.validate(-1) // fails
  /// // error = "My Int: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  @inlinable
  public func errorLabel<S: CustomStringConvertible>(_ label: S, inline: Bool = false)
    -> Validators.ErrorLabelValidator<Self>
  {
    self.errorLabel(label.description, inline: inline)
  }

  /// Add a label to the error(s) for this ``Validation``.
  ///
  /// **Example**
  /// ```swift
  /// enum MyErrorLabels: String {
  ///   case myInt
  ///   case myString
  /// }
  ///
  /// let validator = Int.greaterThan(0).errorLabel(MyErrorLabels.myInt, inline: true)
  ///
  /// try validator.validate(-1) // fails
  /// // error = "myInt: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  @inlinable
  public func errorLabel<R: RawRepresentable>(with label: R, inline: Bool = false)
    -> Validators.ErrorLabelValidator<Self>
  where R.RawValue == String {
    self.errorLabel(label.rawValue, inline: inline)
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
  @inlinable
  public func errorLabel(_ label: String, inline: Bool = false)
    -> Validators.ErrorLabelValidator<Self>
  {
    .init(label: label, inlineLabel: inline, validator: self)
  }

  /// Add a label to the error(s) for this ``AsyncValidation``.
  ///
  /// **Example**
  /// ```swift
  /// enum MyErrorLabels: CustomStringConvertible {
  ///   case myInt
  ///   case myString
  ///
  ///   var description: String {
  ///     switch self {
  ///       case .myInt: return "My Int"
  ///       case .myString: return "My String"
  ///     }
  ///   }
  /// }
  ///
  /// let validator = Int.greaterThan(0).async().errorLabel(MyErrorLabels.myInt, inline: true)
  ///
  /// try await validator.validate(-1) // fails
  /// // error = "My Int: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  @inlinable
  public func errorLabel<S: CustomStringConvertible>(_ label: S, inline: Bool = false)
    -> Validators.ErrorLabelValidator<Self>
  {
    self.errorLabel(label.description, inline: inline)
  }

  /// Add a label to the error(s) for this ``AsyncValidation``.
  ///
  /// **Example**
  /// ```swift
  /// enum MyErrorLabels: String {
  ///   case myInt
  ///   case myString
  /// }
  ///
  /// let validator = Int.greaterThan(0).async().errorLabel(MyErrorLabels.myInt, inline: true)
  ///
  /// try validator.validate(-1) // fails
  /// // error = "myInt: -1 is not greater than 0"
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - label: The label to use.
  ///   - inline: Whether to display the label inline with the first error string.
  @inlinable
  public func errorLabel<R: RawRepresentable>(with label: R, inline: Bool = false)
    -> Validators.ErrorLabelValidator<Self>
  where R.RawValue == String {
    self.errorLabel(label.rawValue, inline: inline)
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

    public let label: any CustomStringConvertible
    public let inlineLabel: Bool
    public let validator: Validator

    @inlinable
    public init(
      label: any CustomStringConvertible,
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
      throw ValidationError.failed(label: label.description, error: error, inlineLabel: inlineLabel)
    }
  }
}

extension Validators.ErrorLabelValidator: AsyncValidation where Validator: AsyncValidation {

  @inlinable
  public func validate(_ value: Validator.Value) async throws {
    do {
      try await self.validator.validate(value)
    } catch {
      throw ValidationError.failed(label: label.description, error: error)
    }
  }
}
