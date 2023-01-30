extension Array where Element: Validator {

  /// Create a validator from an array of validators.
  public var validator: some Validator<Element.Value> {
    ValidationBuilder<Element.Value>._SequenceMany(self)
  }
}
