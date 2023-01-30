@resultBuilder
public enum AsyncValidationBuilder<Value> {

  @inlinable
  public static func buildBlock<V: AsyncValidator>(_ components: V) -> _SequenceMany<V>
  where V.Value == Value {
    _SequenceMany([components])
  }

  @inlinable
  public static func buildArray<V: AsyncValidator>(_ components: [V]) -> _SequenceMany<V>
  where V.Value == Value {
    _SequenceMany(components)
  }

  @inlinable
  public static func buildPartialBlock<V: AsyncValidator>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: AsyncValidator, V1: AsyncValidator>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    _Sequence(accumulated, next)
  }

  @inlinable
  public static func buildExpression<V: AsyncValidator>(_ expression: V) -> V
  where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildExpression<V: Validator>(_ expression: V) -> some AsyncValidator<V.Value>
  where V.Value == Value {
    expression.async
  }

  @inlinable
  public static func buildFinalResult<V: AsyncValidator>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  public struct _Sequence<V0: AsyncValidator, V1: AsyncValidator>: AsyncValidator
  where V0.Value == V1.Value {

    @usableFromInline
    let v0: V0

    @usableFromInline
    let v1: V1

    @inlinable
    init(_ v0: V0, _ v1: V1) {
      self.v0 = v0
      self.v1 = v1
    }

    @inlinable
    public func validate(_ value: V0.Value) async throws {
      try await v0.validate(value)
      try await v1.validate(value)
    }
  }

  public struct _SequenceMany<Element: AsyncValidator>: AsyncValidator {
    @usableFromInline
    let elements: [Element]

    @inlinable
    public init(_ elements: [Element]) {
      self.elements = elements
    }

    @inlinable
    public func validate(_ value: Element.Value) async throws {
      for element in elements {
        try await element.validate(value)
      }
    }
  }
}
