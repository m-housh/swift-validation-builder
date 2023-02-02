extension Array where Element: Validation {
  /// Create a validator from an array of validators.
  ///
  /// - Parameters:
  ///   - type: The validation type to build.
  @inlinable
  public func validator(type: ValidationType = .failEarly) -> some Validation<Element.Value> {
    switch type {
    case .accumulating:
      return _SequenceMany.accumulating(self)
    case .failEarly:
      return _SequenceMany.failEarly(self)
    case .oneOf:
      return _SequenceMany.oneOf(self)
    }
  }
}

extension Array where Element: AsyncValidator {

  /// Create a validator from an array of validators.
  /// - Parameters:
  ///   - type: The validation type to build.
  ///
  @inlinable
  public func validator(type: ValidationType = .failEarly) -> some AsyncValidator<Element.Value> {
    switch type {
    case .accumulating:
      return _SequenceMany.accumulating(self)
    case .failEarly:
      return _SequenceMany.failEarly(self)
    case .oneOf:
      return _SequenceMany.oneOf(self)
    }
  }
}

/// Represents the different types of validators that can be created from an `Array` of ``Validator``'s or ``AsyncValidator``'s
///
public enum ValidationType {

  /// A validator that accumulates errors.
  case accumulating

  /// A validator that does not continue after the first error.
  case failEarly

  /// A validator that passes if any of the validators passes.
  case oneOf
}
