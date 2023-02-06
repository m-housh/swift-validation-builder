extension Validation {

  /// Map on the upstream validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public func map<Downstream: Validation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    @ValidationBuilder<Downstream.Value> validation downstream: @escaping () -> Downstream
  )
    -> Validators.MapValue<Self.Value, Downstream.Value, Downstream>
  {
    .init(transform, with: downstream())
  }

  /// Map on the upstream validation value, creating a new validation, where the downstream value
  /// is the same as the upstream value.
  ///
  /// - Parameters:
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public func map<Downstream: Validation>(
    _ downstream: @escaping (Value) -> Downstream
  )
    -> Validators.Map<Self, Downstream, Self.Value>
  {
    .init(upstream: self, downstream: downstream)
  }

  /// Map on the upstream validation, creating a new validation, where the downstream value
  /// to validate is the same as the upstream value.
  ///
  /// - Parameters:
  ///   - downstream: The downstream validation to use for the value.
  @inlinable
  public func map<Downstream: Validation>(
    @ValidationBuilder<Downstream.Value> _ downstream: @escaping () -> Downstream
  )
    -> Validators.Map<Self, Downstream, Self.Value>
  {
    .init(upstream: self, downstream: { _ in downstream() })
  }

}

extension AsyncValidation {
  /// Map on the upstream validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public func map<Downstream: AsyncValidation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    validation downstream: @escaping () -> Downstream
  )
    -> Validators.MapValue<Self.Value, Downstream.Value, Downstream>
  {
    .init(transform, with: downstream())
  }

  /// Map on the upstream validation value, creating a new validation, where the downstream value
  /// is the same as the upstream value.
  ///
  /// - Parameters:
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public func map<Downstream: AsyncValidation>(
    _ downstream: @escaping (Value) -> Downstream
  )
    -> Validators.Map<Self, Downstream, Self.Value>
  {
    .init(upstream: self, downstream: downstream)
  }

  /// Map on the upstream validation, creating a new validation, where the downstream value
  /// to validate is the same as the upstream value.
  ///
  /// - Parameters:
  ///   - downstream: The downstream validation to use for the value.
  @inlinable
  public func map<Downstream: AsyncValidation>(
    _ downstream: @escaping () -> Downstream
  )
    -> Validators.Map<Self, Downstream, Self.Value>
  {
    .init(upstream: self, downstream: { _ in downstream() })
  }

}

extension Validator {

  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: Validation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    with downstream: Downstream
  ) -> Self {
    .init(Validators.MapValue(transform, with: downstream))
  }

  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - builder: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: Validation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    @ValidationBuilder<Downstream.Value> with builder: () -> Downstream
  ) -> Self {
    mapValue(transform, with: builder())
  }

  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - builder: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: Validation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    with builder: @escaping (Value) -> Downstream
  ) -> Self {
    .init(Validators.MapValue(transform, with: builder))
  }
}

extension AsyncValidator {
  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: AsyncValidation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    with downstream: Downstream
  ) -> Self {
    .init(Validators.MapValue(transform, with: downstream))
  }

  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - builder: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: AsyncValidation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    @AsyncValidationBuilder<Downstream.Value> with builder: () -> Downstream
  ) -> Self {
    mapValue(transform, with: builder())
  }

  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - builder: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: AsyncValidation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    with builder: @escaping (Value) -> Downstream
  ) -> Self {
    .init(Validators.MapValue(transform, with: builder))
  }
}

extension Validators {

  /// A validation that maps on the upstream value, to create a downstream validation.
  ///
  /// This is not interacted with directly, instead you use one of the `map` methods on an ``AsyncValidation`` or
  /// a ``Validation``, such as ``AsyncValidator/map(_:)-9gnjp``.
  ///
  public struct Map<Upstream, Downstream, Value> {

    public let upstream: Upstream
    public let downstream: (Value) -> Downstream

    @inlinable
    public init(
      upstream: Upstream,
      downstream: @escaping (Value) -> Downstream
    ) {
      self.upstream = upstream
      self.downstream = downstream
    }

  }

  /// A validation that maps on the upstream value, transforming the upstream value
  /// for the downstream validation..
  ///
  /// This is not interacted with directly, instead you use one of the `map`methods on an ``AsyncValidation`` or
  /// a ``Validation``, or the `mapValue` static methods on an `AsyncValidator` or a `Validator`, such as
  /// ``Validator/mapValue(_:with:)-8xhvp``.
  ///
  public struct MapValue<Input, Output, Downstream> {

    public let transform: (Input) -> Output
    public let downstream: (Input) -> Downstream

    @inlinable
    public init(
      _ transform: @escaping (Input) -> Output,
      with validator: Downstream
    ) {
      self.transform = transform
      self.downstream = { _ in validator }
    }

    @inlinable
    public init(
      _ transform: @escaping (Input) -> Output,
      with validator: @escaping (Input) -> Downstream
    ) {
      self.transform = transform
      self.downstream = validator
    }
  }
}

extension Validators.Map: Validation
where
  Upstream: Validation,
  Downstream: Validation,
  Upstream.Value == Value,
  Downstream.Value == Value
{
  public func validate(_ value: Upstream.Value) throws {
    try upstream.validate(value)
    try downstream(value).validate(value)
  }
}

extension Validators.Map: AsyncValidation
where
  Upstream: AsyncValidation,
  Downstream: AsyncValidation,
  Upstream.Value == Value, Downstream.Value == Value
{
  public func validate(_ value: Upstream.Value) async throws {
    try await upstream.validate(value)
    try await downstream(value).validate(value)
  }
}

extension Validators.MapValue: Validation
where
  Downstream: Validation,
  Downstream.Value == Output
{

  public func validate(_ value: Input) throws {
    let transformed = transform(value)
    try downstream(value).validate(transformed)
  }
}

extension Validators.MapValue: AsyncValidation
where
  Downstream: AsyncValidation,
  Downstream.Value == Output
{

  public func validate(_ value: Input) async throws {
    let transformed = transform(value)
    try await downstream(value).validate(transformed)
  }
}
