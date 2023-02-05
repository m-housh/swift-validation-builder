
extension Validator {

  /// Create a ``Validators/LazyValidator`` validation.
  ///
  /// - Parameters:
  ///   - validator: The validation that gets created lazily.
  ///
  @inlinable
  public static func `lazy`<V: Validation>(
    _ validator: @escaping (Value) -> V
  )
    -> Self
  where V.Value == Value {
    .init(Validators.LazyValidator(validator))
  }
}

extension AsyncValidator {

  /// Create a ``Validators/LazyValidator`` validation.
  ///
  /// - Parameters:
  ///   - validator: The validation that gets created lazily.
  ///
  @inlinable
  public static func `lazy`<V: AsyncValidation>(
    _ validator: @escaping (Value) -> V
  )
    -> Self
  where V.Value == Value {
    .init(Validators.LazyValidator(validator))
  }
}

extension Validators {

  /// A ``Validation`` that is created lazily.
  ///
  /// This generally used when you need access to the value in order to create the
  /// nested validation.  For example, this is used under the hood when creating a ``Validators/ContainsValidator`` validator,
  /// that requires access to the `Collection` and the `Element` using `KeyPath`'s in ``Validator/contains(_:element:)``.
  ///
  ///  **That implementation looks something like below**
  ///
  /// ```swift
  ///  func contains<C: Collection>(
  ///   _ toCollection: KeyPath<Value, C>,
  ///   _ toElement: KeyPath<Value, C.Element>
  ///  ) -> Self {
  ///   .init(
  ///     Validators.Lazy { parent in
  ///       validate(toCollection) {
  ///          C.contains(parent[keyPath: toElement])
  ///        }
  ///      }
  ///    )
  ///  }
  /// ```
  public struct LazyValidator<Value, Validator> {

    @usableFromInline
    let validator: (Value) -> Validator

    /// Create a ``Validators/LazyValidator`` validation.
    ///
    /// - Parameters:
    ///   - validator: The validation that gets created lazily.
    ///
    @inlinable
    public init(
      _ validator: @escaping (Value) -> Validator
    ) {
      self.validator = validator
    }

  }
}

extension Validators.LazyValidator: Validation
where
  Validator: Validation,
  Validator.Value == Value
{

  @inlinable
  public func validate(_ value: Value) throws {
    try validator(value).validate(value)
  }

}

extension Validators.LazyValidator: AsyncValidation
where
  Validator: AsyncValidation,
  Validator.Value == Value
{

  @inlinable
  public func validate(_ value: Value) async throws {
    try await validator(value).validate(value)
  }
}
