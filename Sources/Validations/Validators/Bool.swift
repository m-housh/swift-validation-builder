extension Validators {
  
  public struct BoolValidator<Value>: Validation {
  
    @usableFromInline
    let evaluate: (Value) -> Bool
    
    @usableFromInline
    let bool: Swift.Bool
    
    @inlinable
    init(
      expecting bool: Bool,
      evaluate: @escaping (Value) -> Bool
    ) {
      self.evaluate = evaluate
      self.bool = bool
    }
    
    @inlinable
    public static func `true`(evaluate: @escaping (Value) -> Bool) -> Self {
      self.init(expecting: true, evaluate: evaluate)
    }
    
    @inlinable
    public static func `false`(evaluate: @escaping (Value) -> Bool) -> Self {
      self.init(expecting: false, evaluate: evaluate)
    }
    
    @inlinable
    public func validate(_ value: Value) throws {
      let evaluated = evaluate(value)
      
      guard evaluated == bool else {
        throw ValidationError.failed(summary: "Failed bool evaluation, expected \(bool)")
      }
    }
    
  }
}

extension Validators.BoolValidator where Value == Bool {
  
  @inlinable
  public init(expecting bool: Bool) {
    self.init(expecting: bool, evaluate: { $0 })
  }
}

extension Validator where Value == Bool {
  
  public static func `true`() -> Self {
    .init(Validators.BoolValidator(expecting: true))
  }
  
  public static func `false`() -> Self {
    .init(Validators.BoolValidator(expecting: false))
  }
}

extension Bool: Validation {
  public typealias Value = Swift.Bool
  
  public var body: some Validation<Self> {
    Validators.BoolValidator(expecting: self)
  }
}
