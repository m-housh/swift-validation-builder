
extension Validation {
//  public func map(
//    _ transform: @escaping (Value) throws -> ()
//  ) -> Validators.Map<Self, AnyValidator<Value>> {
//    Validators.Map(upstream: self, downstream: AnyValidator(transform))
//  }
  
  public func map<C: Validation>(
    _ conversion: @escaping (Value) -> C
  ) -> Validators.Map<Self, C> {
    .init(upstream: self, downstream: conversion)
  }
}

extension Validators {

//  public struct Map<Upstream: Validation>: Validation {
//
//    public let upstream: Upstream
//
//    public let transform: (Upstream.Value) throws -> ()
//
//    @inlinable
//    public func validate(_ value: Upstream.Value) throws {
//      try upstream.validate(value)
//      try transform(value)
//    }
//  }
  
  public struct Map<Upstream: Validation, Downstream: Validation>: Validation
  where Upstream.Value == Downstream.Value
  {

    public let upstream: Upstream
    public let downstream: (Upstream.Value) -> Downstream

    @inlinable
    public init(
      upstream: Upstream,
      downstream: @escaping (Upstream.Value) -> Downstream
    ) {
      self.upstream = upstream
      self.downstream = downstream
    }

    public func validate(_ value: Upstream.Value) throws {
      try upstream.validate(value)
      try downstream(value).validate(value)
    }
  }
  
  public struct MapValue<Input, Output>: Validation {
    
    public let transform: (Input) -> Output
    public let downstream: any Validation<Output>
    
    @inlinable
    public init(
      _ transform: @escaping (Input) -> Output,
      using validator: any Validation<Output>
    ) {
      self.transform = transform
      self.downstream = validator
    }
    
    @inlinable
    public init(
      _ transform: @escaping (Input) -> Output,
      using validator: Validator<Output>
    ) {
      self.transform = transform
      self.downstream = validator
    }
    
    public func validate(_ value: Input) throws {
      let transformed = transform(value)
      try downstream.validate(transformed)
    }
    
  }
}
