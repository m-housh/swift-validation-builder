extension Validators {
  
  public struct BoolValidator<Value>: Validator {
  
    @usableFromInline
    let evaluate: (Value) -> Bool
    
    @usableFromInline
    let bool: Swift.Bool
    
    @inlinable
    public init(
      expecting bool: Bool,
      evaluate: @escaping (Value) -> Bool
    ) {
      self.evaluate = evaluate
      self.bool = bool
    }
    
    public static func `true`(evaluate: @escaping (Value) -> Bool) -> Self {
      self.init(expecting: true, evaluate: evaluate)
    }
    
    public static func `false`(evaluate: @escaping (Value) -> Bool) -> Self {
      self.init(expecting: false, evaluate: evaluate)
    }
    
    public func validate(_ value: Value) throws {
      let evaluated = evaluate(value)
      
      guard evaluated == bool else {
        let end = bool ? "true" : "false"
        throw ValidationError.failed(summary: "Failed bool evaluation, expected \(end)")
      }
    }
    
  }
}

extension Validators.BoolValidator where Value == Bool {
  
  @inlinable
  public init(expecting bool: Bool) {
    self.init(expecting: bool, evaluate: { $0 })
  }
  
  @inlinable
  public static func `true`() -> Self {
    self.true(evaluate: { $0 })
  }
  
  @inlinable
  public static func `false`() -> Self {
    self.false(evaluate: { $0 })
  }
}

extension Validation where Value == Bool {
  
  public static func `true`() -> Self {
    .init(Validators.BoolValidator.true())
  }
  
  public static func `false`() -> Self {
    .init(Validators.BoolValidator.false())
  }
}

extension Bool: Validator {
  public typealias Value = Swift.Bool
  
  public var body: some Validator<Self> {
    Validators.BoolValidator(expecting: self)
  }
}

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
//public struct False<Value>: Validator {
//
//  @usableFromInline
//  let closure: (Value) -> Bool
//
//  /// Create a ``False`` validator with custom evaluation logic
//  ///
//  /// - Parameters:
//  ///   - closure: The logic to run to evaluate the value.
//  @inlinable
//  public init(_ closure: @escaping (Value) -> Bool) {
//    self.closure = closure
//  }
//
//  @inlinable
//  public func validate(_ value: Value) throws {
//    guard closure(value) == false else {
//      throw ValidationError.failed(summary: "Expected to evaluate to false.")
//    }
//  }
//}
//
//extension False where Value == Bool {
//
//  /// Create a ``False`` validator.
//  /// **Example**
//  /// ```swift
//  /// let falseValidator = ValidatorOf<Bool> {
//  ///   False()
//  /// }
//  ///
//  /// try falseValidator.validate(false) // succeeds.
//  /// try falseValidator.validate(true) // fails.
//  /// ```
//  ///
//  @inlinable
//  public init() {
//    self.init({ bool in
//      return bool
//    })
//  }
//}
