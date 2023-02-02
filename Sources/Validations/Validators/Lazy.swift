
extension Validators {
  
  public struct Lazy<Value>: Validation {
    
    @usableFromInline
    let closure: (Value) -> any Validation<Value>
    
    @inlinable
    public init(
      closure: @escaping (Value) -> any Validation<Value>
    ) {
      self.closure = closure
    }
    
    @inlinable
    public func validate(_ value: Value) throws {
      try closure(value).validate(value)
    }
  }
}

