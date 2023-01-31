/// A validator builder that passes if any of the validators succeed.
@resultBuilder
public enum OneOfBuilder<Value> {

//  @inlinable
//  public static func buildBlock<V: Validator>(_ components: V...) -> _SequenceMany<V>
//  where V.Value == Value {
//    .oneOf(components)
//  }
//
//  @inlinable
//  public static func buildArray<V: Validator>(_ components: [V]) -> _SequenceMany<V>
//  where V.Value == Value {
//    .oneOf(components)
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
    .oneOf(accumulated, next)
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
  public static func buildOptional<V: Validator>(_ component: V?) -> V? where V.Value == Value {
    component
  }

  @inlinable
  public static func buildLimitedAvailability<V: Validator>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildEither<True: Validator, False: Validator>(
    first component: True
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<True: Validator, False: Validator>(
    second component: False
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .second(component)
  }

}
