import Foundation

public protocol AsyncValidator<Value> {
  
  associatedtype Value
  
  associatedtype _Body
  
  typealias Body = _Body
  
  func validate(_ value: Value) async throws
  
  @AsyncValidationBuilder<Value>
  var body: Body { get }
}

extension AsyncValidator where Body == Never {
  
  @_transparent
  public var body: Body {
    fatalError("\(Self.self) has no body.")
  }
}

extension AsyncValidator {

  @inlinable
  public var validator: some AsyncValidator<Self.Value> {
    AsyncValidation(self)
  }
}

extension AsyncValidator where Body: AsyncValidator, Body.Value == Value {
  
  @inlinable
  public func validate(_ value: Value) async throws {
    try await self.body.validate(value)
  }
}

public protocol AsyncValidatable: AsyncValidator where Value == Self {
  func validate() async throws
}

extension AsyncValidatable where Self: AsyncValidator, Value == Self {
  
  @inlinable
  public func validate() async throws {
    try await self.validate(self)
  }
}


