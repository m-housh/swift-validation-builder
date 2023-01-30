/// Ensures one of the validators succeds to validate a value.
///
/// **Example**
/// ```
/// let oneOrTwo = ValidatorOf<Int> {
///   OneOf {
///     Equals(1)
///     Equals(2)
///   }
/// }
///
/// try oneOrTwo.validate(1) // success.
/// try oneOrTwo.validate(2) // success.
/// try oneOrTwo.validate(3) // fails.
/// ```
///
public struct OneOf<Value>: Validator {

  @usableFromInline
  let validator: any Validator<Value>

  @inlinable
  init(_ validator: any Validator<Value>) {
    self.validator = validator
  }

  /// Create a one of validator using builder syntax.
  /// **Example**
  /// ```
  /// let oneOrTwo = ValidatorOf<Int> {
  ///   OneOf {
  ///     Equals(1)
  ///     Equals(2)
  ///   }
  /// }
  ///
  /// try oneOrTwo.validate(1) // success.
  /// try oneOrTwo.validate(2) // success.
  /// try oneOrTwo.validate(3) // fails.
  /// ```
  ///
  @inlinable
  public init<V: Validator>(@OneOfBuilder<Value> builder: @escaping () -> V)
  where V.Value == Value {
    self.init(builder())
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try validator.validate(value)
  }
}

/// A validator builder that passes if any of the validators succeed.
@resultBuilder
public enum OneOfBuilder<Value> {

  @inlinable
  public static func buildBlock<V: Validator>(_ components: V) -> _SequenceMany<V>
  where V.Value == Value {
    _SequenceMany([components])
  }

  @inlinable
  public static func buildArray<V: Validator>(_ components: [V]) -> _SequenceMany<V>
  where V.Value == Value {
    _SequenceMany(components)
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
  public static func buildExpression<V: Validator>(_ expression: V) -> V where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildFinalResult<V: Validator>(_ component: V) -> V where V.Value == Value {
    component
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
      do {
        try v0.validate(value)
        return  // early out if successful.
      } catch {
        try v1.validate(value)
      }
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
        do {
          try element.validate(value)
          return  // early out if successful.
        }
      }
    }
  }
}
