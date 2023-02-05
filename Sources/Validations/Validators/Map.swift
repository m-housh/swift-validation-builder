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
    validation downstream: @escaping () -> Downstream
  )
  -> Validators.MapValue<Self.Value, Downstream.Value, Downstream>
  {
    .init(transform, using: downstream())
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
    _ downstream: @escaping () -> Downstream
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
  ) -> Validators.MapValue<Self.Value, Downstream.Value, Downstream> {
    .init(transform, using: downstream())
  }
  
  /// Map on the upstream validation value, creating a new validation, where the downstream value
  /// is the same as the upstream value.
  ///
  /// - Parameters:
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public func map<Downstream: AsyncValidation>(
    _ downstream: @escaping (Value) -> Downstream
  ) -> Validators.Map<Self, Downstream, Self.Value> {
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
  ) -> Validators.Map<Self, Downstream, Self.Value> {
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
    .init(Validators.MapValue(transform, using: downstream))
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
    .init(Validators.MapValue(transform, using: downstream))
  }
  
  /// Map on the validation value, creating a new validation, where the upstream
  /// value is required in order to create the downstream validation and the downstream
  /// validation is a synchronous validation, that gets transformed into an asynchrounous validation.
  ///
  /// - Parameters:
  ///   - transform: Transform the upstream value to the new downstream value.
  ///   - downstream: The downstream validation to use for the downstream value.
  @inlinable
  public static func mapValue<Downstream: Validation>(
    _ transform: @escaping (Value) -> Downstream.Value,
    with downstream: Downstream
  ) -> Self {
    .mapValue(transform, with: downstream.async())
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
}

extension Validators {

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

  public struct MapValue<Input, Output, Downstream> {

    public let transform: (Input) -> Output
    public let downstream: Downstream

    @inlinable
    public init(
      _ transform: @escaping (Input) -> Output,
      using validator: Downstream
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
    try downstream.validate(transformed)
  }
}

extension Validators.MapValue: AsyncValidation
where
  Downstream: AsyncValidation,
  Downstream.Value == Output
{

  public func validate(_ value: Input) async throws {
    let transformed = transform(value)
    try await downstream.validate(transformed)
  }
}

extension Validators.MapValue where Downstream == Validator<Output> {

  @inlinable
  init(
    _ transform: @escaping (Input) -> Output,
    using validator: Validator<Output>
  ) {
    self.transform = transform
    self.downstream = validator
  }
}
