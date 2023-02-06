extension Optional: Validation where Wrapped: Validation {

  @inlinable
  public func validate(_ value: Wrapped.Value) throws {
    if let validator = self {
      try validator.validate(value)
    }
  }
}

extension Optional: AsyncValidation where Wrapped: AsyncValidation {

  @inlinable
  public func validate(_ value: Wrapped.Value) async throws {
    if let validator = self {
      try await validator.validate(value)
    }
  }
}
