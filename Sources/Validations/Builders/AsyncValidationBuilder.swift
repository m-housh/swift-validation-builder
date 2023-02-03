@resultBuilder
public enum AsyncValidationBuilder<Value> {

  @inlinable
  public static func buildPartialBlock<V: AsyncValidation>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: AsyncValidation, V1: AsyncValidation>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    _Sequence.failEarly(accumulated, next)
  }

  @inlinable
  public static func buildExpression<V: AsyncValidation>(_ expression: V) -> V
  where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildExpression<V: Validation>(_ expression: V) -> some AsyncValidation<V.Value>
  where V.Value == Value {
    expression.async
  }

  @inlinable
  public static func buildFinalResult<V: AsyncValidation>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildLimitedAvailability<V: AsyncValidation>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildOptional<V: AsyncValidation>(_ component: V?) -> V?
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildEither<True: AsyncValidation, False: AsyncValidation>(
    first component: True
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<True: AsyncValidation, False: AsyncValidation>(
    second component: False
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .second(component)
  }
}
