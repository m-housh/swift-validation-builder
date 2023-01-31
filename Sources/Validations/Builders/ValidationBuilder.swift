/// A  validation builder.
///
@resultBuilder
public enum ValidationBuilder<Value> {
  // Not supplying a <Value> with validation builder causes it to have to be supplied for all the validators inside the
  // build context, which is no fun / creates a poor user experience.

  //  @inlinable
  //  public static func buildBlock<V: Validator>(_ components: V...) -> _SequenceMany<V>
  //  where V.Value == Value {
  //    .earlyOut(components)
  //  }
  //
  //  @inlinable
  //  public static func buildArray<V: Validator>(_ components: [V]) -> _SequenceMany<V>
  //  where V.Value == Value {
  //    .earlyOut(components)
  //  }

  @inlinable
  public static func buildPartialBlock<V: Validator>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: Validator, V1: Validator>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    .earlyOut(accumulated, next)
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

  @inlinable
  public static func buildLimitedAvailability<V: Validator>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildOptional<V: Validator>(_ component: V?) -> V? where V.Value == Value {
    component
  }
}
