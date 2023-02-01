/// A validator that fails if an expression evaluates to `false`.
///
/// **Example**
/// ```swift
/// let falseValidator = ValidatorOf<Bool> {
///   False()
/// }
///
/// try falseValidator.validate(false) // succeeds.
/// try falseValidator.validate(true) // fails.
/// ```
///
public struct False<Value>: Validator {

  @usableFromInline
  let closure: (Value) -> Bool

  /// Create a ``False`` validator with custom evaluation logic
  ///
  /// - Parameters:
  ///   - closure: The logic to run to evaluate the value.
  @inlinable
  public init(_ closure: @escaping (Value) -> Bool) {
    self.closure = closure
  }

  @inlinable
  public func validate(_ value: Value) throws {
    guard closure(value) == false else {
      throw ValidationError.failed(summary: "Expected to evaluate to false.")
    }
  }
}

extension False where Value == Bool {

  /// Create a ``False`` validator.
  /// **Example**
  /// ```swift
  /// let falseValidator = ValidatorOf<Bool> {
  ///   False()
  /// }
  ///
  /// try falseValidator.validate(false) // succeeds.
  /// try falseValidator.validate(true) // fails.
  /// ```
  ///
  @inlinable
  public init() {
    self.init({ bool in
      return bool
    })
  }
}
