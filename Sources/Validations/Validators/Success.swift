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
  public struct Success<Value>: Validation {

    @inlinable
    public init() {}

    @inlinable
    public func validate(_ value: Value) throws {
      // do nothing.
    }
  }
}

extension Validator {

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
    .init(Validators.Success())
  }
}

//public typealias Always = Validators.Success
