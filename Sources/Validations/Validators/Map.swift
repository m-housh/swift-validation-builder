extension Validation {

  @inlinable
  public func map<Conversion: Validation>(
    _ transform: @escaping (Value) -> Conversion.Value,
    validation: @escaping () -> Conversion
  ) -> Validators.MapValue<Self.Value, Conversion.Value, Conversion> {
    .init(transform, using: validation())
  }

  @inlinable
  public func map<Conversion: Validation>(
    _ conversion: @escaping (Value) -> Conversion
  ) -> Validators.Map<Self, Conversion, Self.Value> {
    .init(upstream: self, downstream: conversion)
  }

  @inlinable
  public func map<Conversion: Validation>(
    _ conversion: @escaping () -> Conversion
  ) -> Validators.Map<Self, Conversion, Self.Value> {
    .init(upstream: self, downstream: { _ in conversion() })
  }

}

extension AsyncValidation {

  @inlinable
  public func map<Conversion: AsyncValidation>(
    _ transform: @escaping (Value) -> Conversion.Value,
    validation: @escaping () -> Conversion
  ) -> Validators.MapValue<Self.Value, Conversion.Value, Conversion> {
    .init(transform, using: validation())
  }

  @inlinable
  public func map<Conversion: AsyncValidation>(
    _ conversion: @escaping (Value) -> Conversion
  ) -> Validators.Map<Self, Conversion, Self.Value> {
    .init(upstream: self, downstream: conversion)
  }

  @inlinable
  public func map<Conversion: AsyncValidation>(
    _ conversion: @escaping () -> Conversion
  ) -> Validators.Map<Self, Conversion, Self.Value> {
    .init(upstream: self, downstream: { _ in conversion() })
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

extension Validators.MapValue: Validation where Downstream: Validation, Downstream.Value == Output {

  public func validate(_ value: Input) throws {
    let transformed = transform(value)
    try downstream.validate(transformed)
  }
}

extension Validators.MapValue: AsyncValidation
where Downstream: AsyncValidation, Downstream.Value == Output {

  public func validate(_ value: Input) async throws {
    let transformed = transform(value)
    try await downstream.validate(transformed)
  }
}

extension Validators.MapValue where Downstream == Validator<Output> {

  @inlinable
  public init(
    _ transform: @escaping (Input) -> Output,
    using validator: Validator<Output>
  ) {
    self.transform = transform
    self.downstream = validator
  }
}
