
extension String {
  /// A ``Validation`` that validates a string is a valid email.
  ///
  /// **Example**
  /// ```swift
  ///
  /// let emailValidator = String.email()
  ///
  /// try emailValidator.validate("blob@example.com") // succeeds.
  /// try emailValidator.validate("blob.example.com") // fails.
  ///
  /// ```
  ///
  /// - Parameters:
  ///   - style: The email style to validate.
  ///
  @inlinable
  public static func email(
    _ style: Validators.EmailValidator<Validator<String>>.Style = .default
  ) -> Validators.EmailValidator<Validator<String>> {
    .init(style: style)
  }

}

