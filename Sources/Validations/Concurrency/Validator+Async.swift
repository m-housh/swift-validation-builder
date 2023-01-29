extension Validator {
  @inlinable
  public var async: some AsyncValidator<Value> {
    AsyncValidation(self)
  }
}
