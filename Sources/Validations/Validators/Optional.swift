extension Optional: Validation where Wrapped: Validation {

  public func validate(_ value: Wrapped.Value) throws {
    if let validator = self {
      try validator.validate(value)
    }
  }
}

extension Optional: AsyncValidator where Wrapped: AsyncValidator {

  public func validate(_ value: Wrapped.Value) async throws {
    if let validator = self {
      try await validator.validate(value)
    }
  }
}
