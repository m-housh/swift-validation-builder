/// A  validation builder.
///
@resultBuilder
public enum ValidationBuilder<Value> {
  // TODO: Complete for limited availablity, etc.
  // Not supplying a <Value> with validation builder causes it to have to be supplied for all the validators inside the
  // build context, which is no fun / creates a poor user experience.

  @inlinable
  public static func buildBlock<V: Validator>(_ validator: V) -> V where V.Value == Value {
    return validator
  }

  @inlinable
  public static func buildPartialBlock<V: Validator>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: Validator, V1: Validator>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    _Sequence(accumulated, next)
  }

  @inlinable
  public static func buildIf<V: Validator>(_ validator: V?) -> _Optional<V> {
    .init(validator)
  }

  @inlinable
  public static func buildEither<TrueValidator: Validator, FalseValidator: Validator>(
    first component: TrueValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<TrueValidator: Validator, FalseValidator: Validator>(
    second component: FalseValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .second(component)
  }

  @inlinable
  public static func buildExpression<V: Validator>(_ expression: V) -> V where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildFinalResult<V: Validator>(_ component: V) -> V where V.Value == Value {
    component
  }

  public enum _Conditional<TrueValidator, FalseValidator>: Validator
  where
    TrueValidator: Validator, FalseValidator: Validator, TrueValidator.Value == FalseValidator.Value
  {
    case first(TrueValidator)
    case second(FalseValidator)

    @inlinable
    public func validate(_ value: TrueValidator.Value) throws {
      switch self {
      case let .first(first):
        return try first.validate(value)
      case let .second(second):
        return try second.validate(value)
      }
    }
  }

  public struct _Optional<V: Validator>: Validator {

    @usableFromInline
    let optionalValidator: V?

    @inlinable
    init(_ optionalValidator: V?) {
      self.optionalValidator = optionalValidator
    }

    @inlinable
    public func validate(_ value: V.Value) throws {
      guard let optionalValidator = optionalValidator else {
        return
      }
      try optionalValidator.validate(value)
    }
  }

  public struct _Sequence<V0: Validator, V1: Validator>: Validator where V0.Value == V1.Value {

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
    public func validate(_ value: V0.Value) throws {
      try v0.validate(value)
      try v1.validate(value)
    }
  }

  public struct _SequenceMany<Element: Validator>: Validator {
    @usableFromInline
    let elements: [Element]

    @inlinable
    public init(_ elements: [Element]) {
      self.elements = elements
    }

    @inlinable
    public func validate(_ value: Element.Value) throws {
      for element in elements {
        try element.validate(value)
      }
    }
  }
}
