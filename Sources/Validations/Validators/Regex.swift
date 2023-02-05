extension Validator where Value == String {

  /// A ``Validator`` that matches a regular expression pattern for validation.
  ///
  ///
  /// - Parameters:
  ///   - pattern: The regex pattern to use for validations.
  ///
  @inlinable
  public static func regex(matching pattern: String) -> Self {
    .init(Validators.RegexValidator<Self>(pattern: pattern))
  }
}

extension AsyncValidator where Value == String {

  /// A ``AsyncValidator`` that matches a regular expression pattern for validation.
  ///
  ///
  /// - Parameters:
  ///   - pattern: The regex pattern to use for validations.
  ///
  @inlinable
  public static func regex(matching pattern: String) -> Self {
    .init(Validators.RegexValidator<Self>(pattern: pattern))
  }
}

// TODO: Use Regex
extension Validators {

  /// A ``Validation`` that matches a regular expression pattern for validation.
  ///
  ///
  public struct RegexValidator<ValidationType> {

    /// The regex pattern string.
    public let pattern: String

    /// Create a new regix validator.
    ///
    /// - Parameters:
    ///   - pattern: The regex pattern to use for validations.
    ///
    @inlinable
    public init(pattern: String) {
      self.pattern = pattern
    }

  }
}

extension Validators.RegexValidator: Validation where ValidationType: Validation {
  @inlinable
  public func validate(_ value: String) throws {
    guard let range = value.range(of: pattern, options: [.regularExpression]),
      range.lowerBound == value.startIndex && range.upperBound == value.endIndex
    else {
      throw ValidationError.failed(summary: "Did not match expected pattern.")
    }
  }
}

extension Validators.RegexValidator: AsyncValidation where ValidationType: AsyncValidation {
  @inlinable
  public func validate(_ value: String) async throws {
    guard let range = value.range(of: pattern, options: [.regularExpression]),
      range.lowerBound == value.startIndex && range.upperBound == value.endIndex
    else {
      throw ValidationError.failed(summary: "Did not match expected pattern.")
    }
  }
}
