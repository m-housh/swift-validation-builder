/// A  validation builder that constructs a validation from closures. The constructed validation
/// runs a number of validators, one after the other, failing upon first validation that fails.
///
/// The ``Validator`` is the entry point to using `@ValidationBuilder` syntax, where you can list
/// all the validations that you want to run.  For example, to validate a string is not empty and contains an '@'
/// character:
///
/// ```swift
/// try Validator<String> {
///   String.notEmtpy()
///   String.contains("@")
/// }.validate("blob@example.com") // succeeds.
/// ```
///
@resultBuilder
public enum ValidationBuilder<Value> {
  // Not supplying a <Value> with validation builder causes it to have to be supplied for all the validators inside the
  // build context, which is no fun / creates a poor user experience.

  /// Provides support for single elements in ``ValidationBuilder`` blocks.
  ///
  /// ```swift
  /// Validator<String> { String.notEmpty() }
  /// ```
  @inlinable
  public static func buildPartialBlock<V: Validation>(first: V) -> V where V.Value == Value {
    first
  }

  /// Provides support for multiple elements in ``ValidationBuilder`` blocks.  Allows the builder to work like
  /// `reduce` on sequences, starting with a validator then if it succeeds moving to the next validator.
  ///
  /// ```swift
  /// Validator<String> {
  ///   String.notEmpty()
  ///   String.contains("@")
  /// }
  /// ```
  @inlinable
  public static func buildPartialBlock<V0: Validation, V1: Validation>(
    accumulated: V0,
    next: V1
  ) -> _Sequence<V0, V1> {
    .failEarly(accumulated, next)
  }

  /// Provides support for `if`-`else` statements in ``ValidationBuilder`` context, producing conditional
  /// validator for the `if` block.
  ///
  /// ```swift
  /// Validator<String> {
  ///   if shouldAllowEmpty {
  ///     Validators.Success()
  ///   } else {
  ///     String.notEmpty()
  ///   }
  /// }
  /// ```
  @inlinable
  public static func buildEither<TrueValidator: Validation, FalseValidator: Validation>(
    first component: TrueValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .first(component)
  }

  /// Provides support for `if`-`else` statements in ``ValidationBuilder`` context, producing conditional
  /// validator for the `else` block.
  ///
  /// ```swift
  /// Validator<String> {
  ///   if shouldAllowEmpty {
  ///     Validators.Success()
  ///   } else {
  ///     String.notEmpty()
  ///   }
  /// }
  /// ```
  @inlinable
  public static func buildEither<TrueValidator: Validation, FalseValidator: Validation>(
    second component: FalseValidator
  ) -> _Conditional<TrueValidator, FalseValidator>
  where TrueValidator.Value == Value, FalseValidator.Value == Value {
    .second(component)
  }

  /// Provides contextual information for statements building partial results.
  ///
  @inlinable
  public static func buildExpression<V: Validation>(_ expression: V) -> V where V.Value == Value {
    expression
  }

  /// Provides support for `if #available` statements in ``ValidationBuilder`` blocks.
  ///
  @inlinable
  public static func buildLimitedAvailability<V: Validation>(_ component: V) -> V
  where V.Value == Value {
    component
  }

  /// Provides support for `if` blocks, producing an optional validation.
  ///
  /// ```swift
  /// Validator<Int> {
  ///   Int.greaterThan(0)
  ///   if onlyOnes {
  ///     Int.equals(1)
  ///   }
  /// }
  /// ```
  @inlinable
  public static func buildOptional<V: Validation>(_ component: V?) -> V? where V.Value == Value {
    component
  }

}
