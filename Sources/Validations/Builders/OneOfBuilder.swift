/// A validator builder that passes if any of the validators succeed.
@resultBuilder
public enum OneOfBuilder<Value> {

  @inlinable
  public static func buildPartialBlock<V: Validation>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: Validation, V1: Validation>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    .oneOf(accumulated, next)
  }

  @inlinable
  public static func buildExpression<V: Validation>(_ expression: V) -> V where V.Value == Value {
    expression
  }

  @inlinable
  public static func buildFinalResult<V: Validation>(_ component: V) -> V where V.Value == Value {
    component
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
  public static func buildEither<True: Validation, False: Validation>(
    first component: True
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<True: Validation, False: Validation>(
    second component: False
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .second(component)
  }

}
