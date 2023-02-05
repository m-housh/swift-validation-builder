extension Validators {
  /// Validates a child value, generally used when creating a validation for a nested value.
  ///
  /// This type is not interacted with directly, instead use one of the static methods to create
  /// a valid instance, such as the``Validator/validate(_:with:)-9hzlv``.
  ///
  /// **Example**
  ///
  /// ```swift
  /// struct User: Validatable {
  ///   let name: String
  ///   let email: String
  ///
  ///   var body: some Validation<Self> {
  ///     Validator {
  ///       Validator.validate(\.name, with: String.notEmtpy())
  ///       Validator.validate(\.email) {
  ///         String.notEmpty()
  ///         String.contains("@")
  ///       }
  ///     }
  ///   }
  /// }
  /// try User(name: "Blob", email: "blob@example.com").validate() // success.
  /// try User(name: "", email: "blob@example.com").validate() // fails.
  ///
  /// ```
  ///
  /// It can also be used with only a `KeyPath` when the value is ``Validatable``
  ///
  /// **Example**
  ///
  /// ```swift
  /// struct HoldsUser: Validatable {
  ///   let user: User
  ///
  ///   var body: some Validation<Self> {
  ///     Validator.validate(\.user)
  ///   }
  /// }
  ///
  /// try HoldsUser(user: .init(name: "Blob", email: "blob@example.com")).validate() // success.
  /// try HoldsUser(user: .init(name: "Blob", email: "blob.example.com")).validate() // fails.
  ///
  ///```
  public struct ValidateValidator<Parent, Child, ChildValidator> {

    @usableFromInline
    let child: (Parent) -> Child

    @usableFromInline
    let validator: (Parent) -> ChildValidator

    @inlinable
    public init(
      _ child: @escaping (Parent) -> Child,
      validator: @escaping (Parent) -> ChildValidator
    ) {
      self.child = child
      self.validator = validator
    }
  }

}

extension Validators.ValidateValidator: Validation
where
  ChildValidator: Validation,
  ChildValidator.Value == Child
{

  @inlinable
  public func validate(_ parent: Parent) throws {
    let value = child(parent)
    try validator(parent).validate(value)
  }

}

extension Validator {

  @inlinable
  public static func validate<Child>(
    _ toChild: @escaping (Value) -> Child,
    with validator: Validator<Child>
  )
    -> Self
  {
    .init(Validators.ValidateValidator(toChild, validator: { _ in validator }))
  }

  @inlinable
  public static func validate<Child>(
    _ toChild: KeyPath<Value, Child>,
    @ValidationBuilder<Child> build: @escaping () -> some Validation<Child>
  ) -> Self {
    self.validate(toChild, with: build())
  }

  @inlinable
  public static func validate<ChildValidator: Validation>(
    _ toChild: KeyPath<Value, ChildValidator.Value>,
    with validator: ChildValidator
  )
    -> Self
  {
    .init(Validators.ValidateValidator.init(toChild.value(from:), validator: { _ in validator }))
  }

  @inlinable
  public static func validate<Child: Validatable>(
    _ toChild: KeyPath<Value, Child>
  )
    -> Self
  {
    .init(Validators.ValidateValidator.init(toChild.value(from:), validator: toChild.value(from:)))
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
    .init(Validators.ValidateValidator(toChild, validator: { _ in validator }))
  }
  
//  @inlinable
//  public static func validate<Child>(
//    _ toChild: @escaping (Value) -> Child,
//    with validator: Validator<Child>
//  )
//    -> Self
//  {
//    .init(Validators.ValidateValidator(toChild, validator: { _ in validator.async() }))
//  }

  @inlinable
  public static func validate<Child>(
    _ toChild: KeyPath<Value, Child>,
    @AsyncValidationBuilder<Child> build: @escaping () -> some AsyncValidation<Child>
  ) -> Self {
    self.validate(toChild, with: build())
  }

  @inlinable
  public static func validate<ChildValidator: AsyncValidation>(
    _ toChild: KeyPath<Value, ChildValidator.Value>,
    with validator: ChildValidator
  )
    -> Self
  {
    .init(Validators.ValidateValidator.init(toChild.value(from:), validator: { _ in validator }))
  }

  @inlinable
  public static func validate<Child: AsyncValidatable>(
    _ toChild: KeyPath<Value, Child>
  )
    -> Self
  {
    .init(Validators.ValidateValidator.init(toChild.value(from:), validator: toChild.value(from:)))
  }
}

extension Validators.ValidateValidator: AsyncValidation
where
  ChildValidator: AsyncValidation,
  ChildValidator.Value == Child
{

  @inlinable
  public func validate(_ parent: Parent) async throws {
    let value = child(parent)
    try await validator(parent).validate(value)
  }

}
