extension Validator {

  /// Wraps a synchronous validator in an asynchronous validator.
  @inlinable
  public var async: some AsyncValidator<Value> {
    AsyncValidation(self)
  }
}
