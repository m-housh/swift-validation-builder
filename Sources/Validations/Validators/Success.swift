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
  /// let always = Validation<String>.success()
  ///
  /// try! always.validate("")
  /// // succeeds
  /// ```
  public static func success() -> Self {
    .init(Validators.Success())
  }
}

extension AsyncValidator {

  /// A validator that always succeeds.
  ///
  /// Example:
  /// ```swift
  /// let always = Validation<String>.success()
  ///
  /// try! always.validate("")
  /// // succeeds
  /// ```
  public static func success() -> Self {
    Validators.Success().async
  }
}
//public typealias Always = Validators.Success
