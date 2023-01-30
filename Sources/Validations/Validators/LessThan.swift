public struct LessThan<Value, Element: Comparable>: Validator {

  @usableFromInline
  let lhs: (Value) -> Element

  @usableFromInline
  let rhs: (Value) -> Element

  @inlinable
  public init(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) {
    self.lhs = lhs
    self.rhs = rhs
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) {
    self.init(lhs.value(from:), rhs.value(from:))
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) {
    self.init(lhs.value(from:), { _ in rhs })
  }

  @inlinable
  public init(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) {
    self.init({ _ in lhs }, rhs.value(from:))
  }

  @inlinable
  public func validate(_ value: Value) throws {
    let lhs = self.lhs(value)
    let rhs = self.rhs(value)

    guard lhs < rhs else {
      throw ValidationError(message: "\(lhs) is not less than \(rhs)")
    }
  }
}

extension LessThan where Value == Element {

  @inlinable
  public init(_ rhs: Element) {
    self.init(\.self, rhs)
  }

  @inlinable
  public init(_ rhs: KeyPath<Value, Element>) {
    self.init(\.self, rhs)
  }
}

public struct LessThanOrEquals<Value, Element>: Validator
where Element: Comparable, Element: Equatable {

  @usableFromInline
  let lhs: (Value) -> Element

  @usableFromInline
  let rhs: (Value) -> Element

  @inlinable
  public init(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) {
    self.lhs = lhs
    self.rhs = rhs
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) {
    self.init(lhs.value(from:), rhs.value(from:))
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) {
    self.init(lhs.value(from:), { _ in rhs })
  }

  @inlinable
  public var body: some Validator<Value> {
    LessThan(lhs, rhs)
      .or(Equals(lhs, rhs))
  }

}

extension LessThanOrEquals where Value == Element {

  @inlinable
  public init(_ element: Element) {
    self.init(\.self, element)
  }
}
