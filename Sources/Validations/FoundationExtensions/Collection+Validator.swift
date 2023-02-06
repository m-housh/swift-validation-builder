extension Collection where Element: Equatable {

  /// Create a ``Validators/Contains`` from a `Collection` type.
  ///
  /// This primarily used when inside one of the result builder contexts, such as a``ValidationBuilder``.
  ///
  /// >  Note: When not inside of a validation builder  context you will need
  /// >  to mark your validator's type, to get a ``Validator``.
  /// > `let validator: Validator<String> = String.contains("@")`.
  ///
  ///
  /// - Parameters:
  ///   - element: The element to validate is in the collection.
  @inlinable
  public static func contains(_ element: Element) -> Validator<Self> {
    .contains(element)
  }
}

extension Collection {
  /// Validates a collection is empty.
  ///
  /// ```swift
  ///  let emptyValidator = String.empty()
  ///
  ///  try emptyValidator.validate("") // success.
  ///  try emptyValidator.validate("foo") // fails.
  ///  ```
  ///
  @inlinable
  public static func empty() -> Validator<Self> {
    .empty()
  }
}

extension Collection {

  /// Validaties a collection is not empty.
  ///
  /// **Example**
  /// ```swift
  /// let notEmptyString = String.notEmpty()
  ///
  /// try notEmptyString.validate("blob") // succeeds.
  /// try notEmptyString.validate("") // fails.
  /// ```
  ///
  @inlinable
  public static func notEmpty() -> Validator<Self> {
    .notEmpty()
  }
}
