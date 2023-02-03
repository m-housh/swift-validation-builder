extension Validator where Value == String {
  
  /// A ``Validator`` that matches a regular expression pattern for validation.
  ///
  ///
  /// - Parameters:
  ///   - pattern: The regex pattern to use for validations.
  ///
  @inlinable
  public static func pattern(matching pattern: String) -> Self {
    .init(Validators.Regex(pattern: pattern))
  }
}

// TODO: Use Regex
extension Validators {
  
  /// A ``Validation`` that matches a regular expression pattern for validation.
  ///
  ///
  public struct Regex: Validation {
    
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
    
    @inlinable
    public func validate(_ value: String) throws {
      guard let range = value.range(of: pattern, options: [.regularExpression]),
            range.lowerBound == value.startIndex && range.upperBound == value.endIndex
      else {
        throw ValidationError.failed(summary: "Did not match expected pattern.")
      }
    }
  }
}
