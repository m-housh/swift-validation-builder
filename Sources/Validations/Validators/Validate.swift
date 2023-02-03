extension Validators {
  /// Validates a child value. Generally used when creating a validation for a nested value.
  ///
  /// This type is not interacted with directly, instead use one of the global functions to create
  /// a valid instance, such as ``Validations/Validate(_:using:)-9gdc6``.
  ///
  /// ** Example**
  /// ```swift
  /// struct User: Validatable {
  ///   let name: String
  ///   let email: String
  ///
  ///   var body: some Validator<Self> {
  ///     Validation {
  ///       Validate(\.name, using: String.notEmtpy())
  ///       Validate(\.email) {
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
  ///  **Example**
  /// ```swift
  /// struct HoldsUser: Validatable {
  ///   let user: User
  ///
  ///   var body: some Validator<Self> {
  ///     Validate(\.user)
  ///   }
  /// }
  ///
  /// try HoldsUser(user: .init(name: "Blob", email: "blob@example.com")).validate() // success.
  /// try HoldsUser(user: .init(name: "Blob", email: "blob.example.com")).validate() // fails.
  ///
  ///```
  public struct Validate<Parent, Child, ChildValidator> {

    @usableFromInline
    let child: (Parent) -> Child

    @usableFromInline
    let validator: (Parent) -> ChildValidator

    @usableFromInline
    init(
      _ child: @escaping (Parent) -> Child,
      validator: @escaping (Parent) -> ChildValidator
    ) {
      self.child = child
      self.validator = validator
    }
  }

}

extension Validators.Validate: Validation
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

@inlinable
public func Validate<Parent, Child>(
  _ toChild: @escaping (Parent) -> Child,
  using validator: Validator<Child>
) -> Validators.Validate<Parent, Child, Validator<Child>> {
  .init(toChild, validator: { _ in validator })
}

@inlinable
public func Validate<Parent, Child, ChildValidator: Validation>(
  _ toChild: KeyPath<Parent, Child>,
  @ValidationBuilder<Child> build: @escaping () -> ChildValidator
) -> Validators.Validate<Parent, Child, ChildValidator>
where ChildValidator.Value == Child {
  .init(toChild.value(from:), validator: { _ in build() })
}

@inlinable
public func Validate<Parent, Child>(
  _ toChild: KeyPath<Parent, Child>,
  using validator: any Validation<Child>
) -> Validators.Validate<Parent, Child, AnyValidator<Child>> {
  .init(toChild.value(from:), validator: { _ in validator.eraseToAnyValidator() })
}

@inlinable
public func Validate<Parent, Child: Validatable>(
  _ toChild: KeyPath<Parent, Child>
) -> Validators.Validate<Parent, Child, Child> {
  .init(toChild.value(from:), validator: toChild.value(from:))
}

// MARK: - Async Support

@inlinable
public func Validate<Parent, Child>(
  _ toChild: @escaping (Parent) -> Child,
  using validator: AsyncValidator<Child>
) -> Validators.Validate<Parent, Child, AsyncValidator<Child>> {
  .init(toChild, validator: { _ in validator })
}

@inlinable
public func Validate<Parent, Child, ChildValidator: AsyncValidation>(
  _ toChild: KeyPath<Parent, Child>,
  @AsyncValidationBuilder<Child> build: @escaping () -> ChildValidator
) -> Validators.Validate<Parent, Child, ChildValidator>
where ChildValidator.Value == Child {
  .init(toChild.value(from:), validator: { _ in build() })
}

@inlinable
public func Validate<Parent, Child>(
  _ toChild: KeyPath<Parent, Child>,
  using validator: any AsyncValidation<Child>
) -> Validators.Validate<Parent, Child, AnyAsyncValidator<Child>> {
  .init(toChild.value(from:), validator: { _ in validator.eraseToAnyAsyncValidator() })
}

@inlinable
public func Validate<Parent, Child: AsyncValidatable>(
  _ toChild: KeyPath<Parent, Child>
) -> Validators.Validate<Parent, Child, Child> {
  .init(toChild.value(from:), validator: toChild.value(from:))
}

extension Validators.Validate: AsyncValidation
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
