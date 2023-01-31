extension Array where Element: Validator {
  /// Create a validator from an array of validators.
  ///
  @inlinable
  public func validator(type: ValidationType = .earlyOut) -> some Validator<Element.Value> {
    switch type {
    case .accumulating:
      return _SequenceMany.accumulating(self)
    case .earlyOut:
      return _SequenceMany.earlyOut(self)
    case .oneOf:
      return _SequenceMany.oneOf(self)
    }
  }
}

extension Array where Element: AsyncValidator {
  /// Create a validator from an array of validators.
  ///
  @inlinable
  public func validator(type: ValidationType = .earlyOut) -> some AsyncValidator<Element.Value> {
    switch type {
    case .accumulating:
      return _SequenceMany.accumulating(self)
    case .earlyOut:
      return _SequenceMany.earlyOut(self)
    case .oneOf:
      return _SequenceMany.oneOf(self)
    }
  }
}

public enum ValidationType {
  case accumulating
  case earlyOut
  case oneOf
}
