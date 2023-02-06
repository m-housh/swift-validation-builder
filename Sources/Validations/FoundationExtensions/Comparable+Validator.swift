
// These comparables only return `Validator` types or type-inference doesn't work well, so
// wrap with `.async()` if an async validation is needed.

extension Equatable {

  /// Create a ``Validator`` from an `Equatable` conforming type.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let blobValidator = String.equals("blob")
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value that we should equal when validating other values.
  ///
  @inlinable
  static func equals(_ value: Self) -> Validator<Self> {
    .equals(value)
  }
  
}

// MARK: - Greater Than

extension Comparable {

  /// Create a ``Validator`` that validates the value is greater than the given value
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = Int.greaterThan(10)
  ///
  /// try intValidator.validate(11) // succeeds.
  /// try intValidator.validate(9) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value we should use to compare values are greater than.
  ///
  @inlinable
  public static func greaterThan(_ value: Self) -> Validator<Self> {
    .greaterThan(\.self, value)
  }
  
  /// Create a ``Validator`` that validates the value is greater than or equal to the given value
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = Int.greaterThanOrEquals(10)
  ///
  /// try intValidator.validate(10) // succeeds.
  /// try intValidator.validate(9) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value we should use to compare values are greater than or equal to.
  ///
  @inlinable
  public static func greaterThanOrEquals(_ value: Self) -> Validator<Self> {
    .greaterThanOrEquals(\.self, value)
  }
  
}

// MARK: - Less Than

extension Comparable {

  /// Create a ``Validator`` that validates the value is less than the given value,
  ///
  /// **Example**
  ///```swift
  /// let validator = Int.lessThan(11)
  ///
  /// try validator.validate(10) // succeeds.
  /// try validator.validate(12) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - value: The value that values should be less than during validaiton.
  ///
  @inlinable
  public static func lessThan(_ value: Self) -> Validator<Self> {
    .lessThan(\.self, value)
  }

  /// Create a ``Validator`` that validates the value is less than or equal to the given value,
  ///
  /// **Example**
  ///```swift
  /// let validator = Int.lessThanOrEquals(11)
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 12)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - value: The value that values should be less than or equal to during validaiton.
  ///
  @inlinable
  public static func lessThanOrEquals(_ value: Self) -> Validator<Self> {
    .lessThanOrEquals(\.self, value)
  }

}
