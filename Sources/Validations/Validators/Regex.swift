extension Validator where Value == String {
  
  @inlinable
  public static func pattern(matching pattern: String) -> Self {
    .init(Validators.Regex(pattern: pattern))
  }
}

// TODO: Use Regex
extension Validators {
  
  
  public struct Regex: Validation {
    
    public let pattern: String
    
    @inlinable
    public init(pattern: String) {
      self.pattern = pattern
    }
    
    public func validate(_ value: String) throws {
      guard let range = value.range(of: pattern, options: [.regularExpression]),
            range.lowerBound == value.startIndex && range.upperBound == value.endIndex
      else {
        throw ValidationError.failed(summary: "Did not match expected pattern.")
      }
    }
  }
}
