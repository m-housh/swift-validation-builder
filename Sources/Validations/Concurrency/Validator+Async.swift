extension Validation {

  /// Wraps a synchronous validator in an asynchronous validator.
  @inlinable
  public func async() -> AsyncValidator<Value> {
    AsyncValidator(self)
  }
}
