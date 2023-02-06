
extension Bool: Validation {
  public typealias Value = Swift.Bool

  public var body: some Validation<Self> {
    self.validator()
  }

  /// Access a validator for a given `Swift.Bool`.
  ///
  /// ```swift
  /// let isTrueValidator = true.validator()
  /// ```
  @inlinable
  public func validator() -> Validator<Bool> {
    .bool(expecting: self)
  }
}

extension Bool: AsyncValidation {

  @inlinable
  public func validate(_ value: Self) async throws {
    try await AsyncValidator.bool(expecting: self).validate(value)
  }
}
