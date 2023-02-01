extension Validators {
  /// A validator that always succeeds.
  ///
  /// Example:
  /// ```swift
  /// let always = Always<String>()
  ///
  /// try! always.validate("")
  /// // succeeds
  /// ```
  public struct Always<Value>: Validator {
    
    @inlinable
    public init() {}
    
    @inlinable
    public func validate(_ value: Value) throws {
      // do nothing.
    }
  }
}

extension Validation {
  
  /// A validator that always succeeds.
  ///
  /// Example:
  /// ```swift
  /// let always = Validation<String>.always()
  ///
  /// try! always.validate("")
  /// // succeeds
  /// ```
  public static func always() -> Self {
    .init(Validators.Always())
  }
}
