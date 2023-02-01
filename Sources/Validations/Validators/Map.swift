
extension Validator {
  public func map(
    _ transform: @escaping (Value) throws -> ()
  ) -> Validators.Map<Self> {
    Validators.Map(upstream: self, transform: transform)
  }
  
  public func map<C: Validator>(
    _ conversion: @escaping (Value) -> C
  ) -> Validators.MapConversion<Self, C> {
    .init(upstream: self, downstream: conversion)
  }
  
  
}

extension Validators {

  public struct Map<Upstream: Validator>: Validator {
    
    public let upstream: Upstream
    
    public let transform: (Upstream.Value) throws -> ()
    
    @inlinable
    public func validate(_ value: Upstream.Value) throws {
      try upstream.validate(value)
      try transform(value)
    }
  }
  
  public struct MapConversion<Upstream: Validator, Downstream: Validator>: Validator
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
}
