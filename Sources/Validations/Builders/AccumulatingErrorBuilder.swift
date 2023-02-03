/// A  validation builder.
///
@resultBuilder
public enum AccumulatingErrorBuilder<Value> {
  // Not supplying a <Value> with validation builder causes it to have to be supplied for all the validators inside the
  // build context, which is no fun / creates a poor user experience.

  @inlinable
  public static func buildPartialBlock<V: Validation>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: Validation, V1: Validation>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    _Sequence.accumulating(accumulated, next)
  }

  @inlinable
  public static func buildEither<TrueValidator: Validation, FalseValidator: Validation>(
    first component: TrueValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<TrueValidator: Validation, FalseValidator: Validation>(
    second component: FalseValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .second(component)
  }

  @inlinable
  public static func buildExpression<V: Validation>(_ expression: V) -> V where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildOptional<V: Validation>(_ component: V?) -> V? where V.Value == Value {
    component
  }

  @inlinable
  public static func buildLimitedAvailability<V: Validation>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildPartialBlock<V: AsyncValidation>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: AsyncValidation, V1: AsyncValidation>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    _Sequence.accumulating(accumulated, next)
  }

  @inlinable
  public static func buildEither<TrueValidator: AsyncValidation, FalseValidator: AsyncValidation>(
    first component: TrueValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<TrueValidator: AsyncValidation, FalseValidator: AsyncValidation>(
    second component: FalseValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .second(component)
  }

  @inlinable
  public static func buildExpression<V: AsyncValidation>(_ expression: V) -> V
  where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildOptional<V: AsyncValidation>(_ component: V?) -> V?
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildLimitedAvailability<V: AsyncValidation>(_ component: V) -> V
  where V.Value == Value {
    component
  }
}
