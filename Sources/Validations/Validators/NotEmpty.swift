extension Validators {
  /// A validator that validates a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = ValidatorOf<String> {
  ///   NotEmpty()
  /// }
  ///
  /// try notEmptyString.validate("foo") // success.
  /// try notEmptyString.validate("") //fails.
  /// ```
  ///
  public struct NotEmpty<Value: Collection>: Validator {
    
    public init() {}
    
    public var body: some Validator<Value> {
      Not(Empty())
    }
    
    public func validate(_ value: Value) throws {
      do {
        try self.body.validate(value)
      } catch {
        throw ValidationError.failed(summary: "Expected to not be empty.")
      }
    }
  }
}

extension Validation where Value: Collection {
 
  /// Validaties a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = ValidatorOf<String>.notEmpty()
  ///
  /// try notEmptyString.validate("blob") // succeeds.
  /// try notEmptyString.validate("") // fails.
  /// ```
  @inlinable
  public static func notEmpty() -> Self {
    .init(Validators.NotEmpty())
  }
}

public typealias NotEmpty = Validators.NotEmpty
