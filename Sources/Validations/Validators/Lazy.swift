extension Validators {

  /// A ``Validation`` that is created lazily.
  ///
  /// This generally used when you need access to the value in order to create the
  /// nested validation.  For example, this is used under the hood when creating a ``Validators/Contains`` validator,
  /// that requires access to the `Collection` and the `Element` using `KeyPath`'s in ``Validator/contains(_:_:)-7h8o5``.
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
  ///       Validate(toCollection) {
  ///          C.contains(parent[keyPath: toElement])
  ///        }
  ///      }
  ///    )
  ///  }
  /// ```
  public struct Lazy<Value>: Validation {

    @usableFromInline
    let validator: (Value) -> any Validation<Value>

    /// Create a ``Validators/Lazy`` validation.
    ///
    /// - Parameters:
    ///   - validator: The validation that gets created lazily.
    ///
    @inlinable
    public init(
      _ validator: @escaping (Value) -> any Validation<Value>
    ) {
      self.validator = validator
    }

    @inlinable
    public func validate(_ value: Value) throws {
      try validator(value).validate(value)
    }
  }
}

extension Validator {

  /// Create a ``Validators/Lazy`` validation.
  ///
  /// - Parameters:
  ///   - validator: The validation that gets created lazily.
  ///
  @inlinable
  public static func `lazy`(
    _ validator: @escaping (Value) -> any Validation<Value>
  ) -> Self {
    .init(Validators.Lazy(validator))
  }
}
