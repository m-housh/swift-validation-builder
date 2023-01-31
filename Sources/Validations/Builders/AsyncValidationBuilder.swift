@resultBuilder
public enum AsyncValidationBuilder<Value> {

//  @inlinable
//  public static func buildBlock<V: AsyncValidator>(_ components: V...) -> _SequenceMany<V>
//  where V.Value == Value {
//    .earlyOut(components)
//  }
//
//  @inlinable
//  public static func buildArray<V: AsyncValidator>(_ components: [V]) -> _SequenceMany<V>
//  where V.Value == Value {
//    .earlyOut(components)
//  }

  @inlinable
  public static func buildPartialBlock<V: AsyncValidator>(first: V) -> V where V.Value == Value {
    first
  }

  @inlinable
  public static func buildPartialBlock<V0: AsyncValidator, V1: AsyncValidator>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    _Sequence.earlyOut(accumulated, next)
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

  @inlinable
  public static func buildLimitedAvailability<V: AsyncValidator>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildOptional<V: AsyncValidator>(_ component: V?) -> V?
  where V.Value == Value {
    component
  }

  @inlinable
  public static func buildEither<True: AsyncValidator, False: AsyncValidator>(
    first component: True
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .first(component)
  }

  @inlinable
  public static func buildEither<True: AsyncValidator, False: AsyncValidator>(
    second component: False
  ) -> _Conditional<True, False>
  where True.Value == Value, False.Value == Value {
    .second(component)
  }
}
