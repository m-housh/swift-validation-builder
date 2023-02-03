extension Validation {

  /// Wraps a synchronous validator in an asynchronous validator.
  @inlinable
  public var async: some AsyncValidation<Value> {
    AsyncValidator(self)
  }
}
