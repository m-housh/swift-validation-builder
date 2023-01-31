/// A validator for if a collection contains a value.
///
/// ```
/// let validator = ValidatorOf<String> {
///   Contains("@")
/// }
///
/// try validator.validate("blob@example.com") // success.
/// try validator.validate("blob.jr.example.com") // fails.
///
/// ```
///
public struct Contains<Parent, Value: Collection>: Validator where Value.Element: Equatable {

  @usableFromInline
  let lhs: (Parent) -> Value

  @usableFromInline
  let rhs: (Parent) -> Value.Element

  @inlinable
  public init(
    _ lhs: @escaping (Parent) -> Value,
    _ rhs: @escaping (Parent) -> Value.Element
  ) {
    self.lhs = lhs
    self.rhs = rhs
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Parent, Value>,
    _ rhs: @escaping (Parent) -> Value.Element
  ) {
    self.init(lhs.value(from:), rhs)
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Parent, Value>,
    _ rhs: KeyPath<Parent, Value.Element>
  ) {
    self.init(lhs, rhs.value(from:))
  }

  @inlinable
  public init(
    _ lhs: KeyPath<Parent, Value>,
    _ rhs: Value.Element
  ) {
    self.init(lhs.value(from:), { _ in rhs })
  }

  public func validate(_ parent: Parent) throws {
    let value = lhs(parent)
    let element = rhs(parent)

    guard value.contains(where: { $0 == element }) else {
      throw ValidationError.failed(summary: "Does not contain \(element)")
    }
  }
}

extension Contains where Parent: Collection, Value == Parent {

  @inlinable
  public init(_ rhs: Value.Element) {
    self.init(\.self, rhs)
  }

  @inlinable
  public init(_ rhs: KeyPath<Parent, Value.Element>) {
    self.init(\.self, rhs)
  }

  @inlinable
  public init(_ rhs: @escaping (Parent) -> Value.Element) {
    self.init(\.self, rhs)
  }

}
