extension Validator {

  /// Create a ``Validator`` that validate a child value, using the given validation.
  ///
  /// - Parameters:
  ///   - toChild: Return the child from the value to be validated.
  ///   - validator: The validation to use to validate the child value.
  @inlinable
  public static func validate<Child>(
    _ toChild: @escaping (Value) -> Child,
    with validator: Validator<Child>
  )
    -> Self
  {
    self.mapValue(toChild, with: validator)
  }

  /// Create a ``Validator`` that validate a child value, using the given validation.
  ///
  /// - Parameters:
  ///   - toChild: A `KeyPath` the value to the child value.
  ///   - build: The validation to use to validate the child value.
  @inlinable
  public static func validate<Child>(
    _ toChild: KeyPath<Value, Child>,
    @ValidationBuilder<Child> build: @escaping () -> some Validation<Child>
  ) -> Self {
    self.mapValue(toChild.value(from:), with: build())
  }

  /// Create a ``Validator`` that validate a child value, using the given validation.
  ///
  /// - Parameters:
  ///   - toChild: A `KeyPath` the value to the child value.
  ///   - validator: The validation to use to validate the child value.
  @inlinable
  public static func validate<ChildValidator: Validation>(
    _ toChild: KeyPath<Value, ChildValidator.Value>,
    with validator: ChildValidator
  )
    -> Self
  {
    self.mapValue(toChild.value(from:), with: validator)
  }

  /// Create a ``Validator`` that validate a child value, using the child when it's ``Validatable``
  ///
  /// - Parameters:
  ///   - toChild: A `KeyPath` the value to the child value.
  @inlinable
  public static func validate<Child: Validatable>(
    _ toChild: KeyPath<Value, Child>
  )
    -> Self
  {
    self.mapValue(toChild.value(from:), with: toChild.value(from:))
  }
}

// MARK: - Async Support
extension AsyncValidator {

  @inlinable
  public static func validate<Child>(
    _ toChild: @escaping (Value) -> Child,
    with validator: AsyncValidator<Child>
  )
    -> Self
  {
    self.mapValue(toChild, with: validator)
  }

  @inlinable
  public static func validate<Child>(
    _ toChild: KeyPath<Value, Child>,
    @AsyncValidationBuilder<Child> build: @escaping () -> some AsyncValidation<Child>
  ) -> Self {
    self.mapValue(toChild.value(from:), with: build())
  }

  @inlinable
  public static func validate<ChildValidator: AsyncValidation>(
    _ toChild: KeyPath<Value, ChildValidator.Value>,
    with validator: ChildValidator
  )
    -> Self
  {
    self.mapValue(toChild.value(from:), with: validator)
  }

  @inlinable
  public static func validate<Child: AsyncValidatable>(
    _ toChild: KeyPath<Value, Child>
  )
    -> Self
  {
    self.mapValue(toChild.value(from:), with: toChild.value(from:))

  }
}
