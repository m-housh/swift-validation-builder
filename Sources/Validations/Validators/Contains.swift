extension Validators {
  /// A validator for if a collection contains a value.
  ///
  /// ```swift
  /// let validator = ValidatorOf<String> {
  ///   Contains("@")
  /// }
  ///
  /// try validator.validate("blob@example.com") // success.
  /// try validator.validate("blob.jr.example.com") // fails.
  ///
  /// ```
  ///
  public struct Contains<Value: Collection>: Validation where Value.Element: Equatable {
    
    public let element: Value.Element
    
    @inlinable
    public init(element: Value.Element) {
      self.element = element
    }
    
    public func validate(_ value: Value) throws {
      guard value.contains(element) else {
        throw ValidationError.failed(summary: "Does not contain \(element)")
      }
    }
  }
}

extension Validator {
  
  @inlinable
  public static func contains<C: Collection>(
    _ toCollection: KeyPath<Value, C>,
    _ toElement: KeyPath<Value, C.Element>
  ) -> Self
  where C.Element: Equatable
  {
    .init(
      Validators.Lazy { parent in
        Validate<Value, C>(toCollection) {
          Validators.Contains(element: parent[keyPath: toElement])
        }
      }
    )
  }
  
  @inlinable
  public static func contains<C: Collection>(
    _ toCollection: KeyPath<Value, C>,
    _ element: C.Element
  ) -> Self
  where C.Element: Equatable
  {
    .init(
      Validate<Value, C>(toCollection) {
        Validators.Contains(element: element)
      }
    )
  }
}

extension Validator where Value: Collection, Value.Element: Equatable {
  
  @inlinable
  public static func contains(_ element: Value.Element) -> Self {
    .init(Validators.Contains(element: element))
  }
}

extension Collection where Element: Equatable {
  
  @inlinable
  public static func contains(_ element: Element) -> some Validation<Self> {
    Validators.Contains(element: element)
  }
}
