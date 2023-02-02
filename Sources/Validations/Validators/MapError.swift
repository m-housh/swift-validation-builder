
extension Validation {
  
  @inlinable
  func mapError(_ error: Error) -> Validators.MapError<Self> {
    Validators.MapError(upstream: self, with: error)
  }
}

extension Validators {
  
  public struct MapError<Upstream: Validation>: Validation {
    
    public let upstream: Upstream
    public let error: Error
    
    @inlinable
    public init(upstream: Upstream, with error: Error) {
      self.upstream = upstream
      self.error = error
    }
    
    @inlinable
    public func validate(_ value: Upstream.Value) throws {
      do {
        try upstream.validate(value)
      } catch {
        // map the error.
        throw self.error
      }
    }
  }
}
