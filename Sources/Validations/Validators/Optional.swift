extension Optional: Validator where Wrapped: Validator {

  public func validate(_ value: Wrapped.Value) throws {
    if let validator = self {
      try validator.validate(value)
    }
  }
}
