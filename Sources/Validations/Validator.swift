import Foundation

public protocol Validator<Value> {
  
  associatedtype Value
  
  associatedtype _Body
  
  typealias Body = _Body
  
  func validate(_ value: Value) throws
  
  @ValidationBuilder<Value>
  var body: Body { get }
}

extension Validator where Body == Never {
  
  @_transparent
  public var body: Body {
    fatalError("\(Self.self) has no body.")
  }
}

extension Validator {
  
  @inlinable
  public var validator: some Validator<Self.Value> {
    Validation(self)
  }
}

extension Validator where Body: Validator, Body.Value == Value {
  
  @inlinable
  public func validate(_ value: Value) throws {
    try self.body.validate(value)
  }
}

public protocol Validatable: Validator where Value == Self {
  func validate() throws
}

extension Validatable where Self: Validator, Value == Self {
  
  @inlinable
  public func validate() throws {
    try self.validate(self)
  }
}
