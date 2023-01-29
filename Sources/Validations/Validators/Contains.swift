
public struct Contains<Value: Collection>: Validator where Value.Element: Equatable {
  
  @usableFromInline
  let lhs: (Value) -> Value
  
  @usableFromInline
  let rhs: (Value) -> Value.Element
  
  @inlinable
  public init(
    _ lhs: @escaping (Value) -> Value,
    _ rhs: @escaping (Value) -> Value.Element
  ) {
    self.lhs = lhs
    self.rhs = rhs
  }
  
  @inlinable
  public init(
    _ lhs: KeyPath<Value, Value>,
    _ rhs: @escaping (Value) -> Value.Element
  ) {
    self.init(lhs.value(from:), rhs)
  }
  
  @inlinable
  public init(
    _ lhs: KeyPath<Value, Value>,
    _ rhs: KeyPath<Value, Value.Element>
  ) {
    self.init(lhs.value(from:), rhs.value(from:))
  }
 
  @inlinable
  public init(
    _ lhs: KeyPath<Value, Value>,
    _ rhs: Value.Element
  ) {
    self.init(lhs.value(from:), { _ in rhs })
  }
  
  public func validate(_ value: Value) throws {
    let element = self.rhs(value)
    
    guard value.contains(where: { $0 == element }) else {
      throw ValidationError(message: "Does not contain \(element)")
    }
  }
}

extension Contains {

  @inlinable
  public init(_ rhs: Value.Element) {
    self.init(\.self, rhs)
  }

  @inlinable
  public init(_ rhs: KeyPath<Value, Value.Element>) {
    self.init(\.self, rhs)
  }
  
  @inlinable
  public init(_ rhs: @escaping (Value) -> Value.Element) {
    self.init(\.self, rhs)
  }
  
}

//struct _Contains<Parent, Value: Collection>: Validator where Value.Element: Equatable {
//
//  @usableFromInline
//  let lhs: (Parent) -> Value
//
//  @usableFromInline
//  let rhs: (Parent, Value) -> Value.Element
//
//  @inlinable
//  public func validate(_ value: Parent) throws {
//    let lhs = self.lhs(value)
//    let rhs = self.rhs(value,lhs)
//    guard lhs.contains(where: { $0 == rhs }) else {
//      throw ValidationError(message: "Does not contain \(rhs)")
//    }
//  }
//
//  @inlinable
//  public init(
//    _ lhs: @escaping (Parent) -> Value,
//    _ rhs: @escaping (Parent, Value) -> Value.Element
//  ) {
//    self.lhs = lhs
//    self.rhs = rhs
//  }
//
//  @inlinable
//  public init(
//    _ lhs: KeyPath<Parent, Value>,
//    _ rhs: KeyPath<Parent, Value.Element>
//  ) {
//    self.lhs = lhs.value(from:)
//    self.rhs = { parent, _ in return parent[keyPath: rhs] }
//  }
//
//  @inlinable
//  public init(
//    _ lhs: KeyPath<Parent, Value>,
//    _ rhs: KeyPath<Value, Value.Element>
//  ) {
//    self.lhs = lhs.value(from:)
//    self.rhs = { _, value in return value[keyPath: rhs] }
//  }
//}
//
//extension _Contains where Parent == Value {
//
//  @inlinable
//  internal init(
//    _ rhs: @escaping (Parent) -> Value.Element
//  ) {
//    self.lhs = { parent in return parent }
//    self.rhs = { parent, _ in return rhs(parent) }
//  }
//
//  @inlinable
//  internal init(
//    _ rhs: KeyPath<Parent, Value.Element>
//  ) {
//    self.lhs = { parent in return parent }
//    self.rhs = { parent, _ in return parent[keyPath: rhs] }
//  }
//
//}
