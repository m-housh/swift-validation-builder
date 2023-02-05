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
  public struct SuccessValidator<ValidationType, Value> {

    @inlinable
    public init() {}

  }
}

extension Validators.SuccessValidator: Validation where ValidationType: Validation {
  
  @inlinable
  public func validate(_ value: Value) throws {
    // do nothing.
  }
}

extension Validators.SuccessValidator: AsyncValidation where ValidationType: AsyncValidation {
  
  @inlinable
  public func validate(_ value: Value) throws {
    // do nothing.
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
    .init(Validators.SuccessValidator<Self, Value>())
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
    Validator.success().async()
  }
}
//public typealias Always = Validators.Success
