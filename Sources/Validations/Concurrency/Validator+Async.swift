extension Validation {

  /// Wraps a synchronous validator in an asynchronous validator.
  @inlinable
  public var async: AsyncValidator<Value> {
    AsyncValidator(self)
  }
}
