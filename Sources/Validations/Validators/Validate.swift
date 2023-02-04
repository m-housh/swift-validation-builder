extension Validators {
  /// Validates a child value, generally used when creating a validation for a nested value.
  ///
  /// This type is not interacted with directly, instead use one of the static methods to create
  /// a valid instance, such as ``Validators/Validate(_:with:)-4yq8h``.
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
  ///       Validators.Validate(\.name, with: String.notEmtpy())
  ///       Validators.Validate(\.email) {
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
  ///     Validators.Validate(\.user)
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

extension Validators {
  @inlinable
  public static func Validate<Parent, Child>(
    _ toChild: @escaping (Parent) -> Child,
    with validator: Validator<Child>
  ) -> Validators.ValidateValidator<Parent, Child, Validator<Child>> {
    .init(toChild, validator: { _ in validator })
  }
  
  @inlinable
  public static func Validate<Parent, Child, ChildValidator: Validation>(
    _ toChild: KeyPath<Parent, Child>,
    @ValidationBuilder<Child> build: @escaping () -> ChildValidator
  ) -> Validators.ValidateValidator<Parent, Child, ChildValidator>
  where ChildValidator.Value == Child {
    .init(toChild.value(from:), validator: { _ in build() })
  }
  
  @inlinable
  public static func Validate<Parent, Child>(
    _ toChild: KeyPath<Parent, Child>,
    with validator: any Validation<Child>
  ) -> Validators.ValidateValidator<Parent, Child, AnyValidator<Child>> {
    .init(toChild.value(from:), validator: { _ in validator.eraseToAnyValidator() })
  }
  
  @inlinable
  public static func Validate<Parent, Child: Validatable>(
    _ toChild: KeyPath<Parent, Child>
  ) -> Validators.ValidateValidator<Parent, Child, Child> {
    .init(toChild.value(from:), validator: toChild.value(from:))
  }
}
  
  // MARK: - Async Support
extension Validators {
  
  @inlinable
  public static func Validate<Parent, Child>(
    _ toChild: @escaping (Parent) -> Child,
    with validator: AsyncValidator<Child>
  ) -> Validators.ValidateValidator<Parent, Child, AsyncValidator<Child>> {
    .init(toChild, validator: { _ in validator })
  }
  
  @inlinable
  public static func Validate<Parent, Child, ChildValidator: AsyncValidation>(
    _ toChild: KeyPath<Parent, Child>,
    @AsyncValidationBuilder<Child> build: @escaping () -> ChildValidator
  ) -> Validators.ValidateValidator<Parent, Child, ChildValidator>
  where ChildValidator.Value == Child {
    .init(toChild.value(from:), validator: { _ in build() })
  }
  
  @inlinable
  public static func Validate<Parent, Child>(
    _ toChild: KeyPath<Parent, Child>,
    with validator: any AsyncValidation<Child>
  ) -> Validators.ValidateValidator<Parent, Child, AnyAsyncValidator<Child>> {
    .init(toChild.value(from:), validator: { _ in validator.eraseToAnyAsyncValidator() })
  }
  
  @inlinable
  public static func Validate<Parent, Child: AsyncValidatable>(
    _ toChild: KeyPath<Parent, Child>
  ) -> Validators.ValidateValidator<Parent, Child, Child> {
    .init(toChild.value(from:), validator: toChild.value(from:))
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
