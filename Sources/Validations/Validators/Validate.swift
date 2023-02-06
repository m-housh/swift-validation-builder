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

//extension Validators.ValidateValidator: AsyncValidation
//where
//  ChildValidator: AsyncValidation,
//  ChildValidator.Value == Child
//{
//
//  @inlinable
//  public func validate(_ parent: Parent) async throws {
//    let value = child(parent)
//    try await validator(parent).validate(value)
//  }
//
//}

// MARK: - Validators

//extension Validators {
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
//  public struct ValidateValidator<Parent, Child, ChildValidator> {
//
//    @usableFromInline
//    let child: (Parent) -> Child
//
//    @usableFromInline
//    let validator: (Parent) -> ChildValidator
//
//    @inlinable
//    public init(
//      _ child: @escaping (Parent) -> Child,
//      validator: @escaping (Parent) -> ChildValidator
//    ) {
//      self.child = child
//      self.validator = validator
//    }
//  }
//
//}
//
//extension Validators.ValidateValidator: Validation
//where
//  ChildValidator: Validation,
//  ChildValidator.Value == Child
//{
//
//  @inlinable
//  public func validate(_ parent: Parent) throws {
//    let value = child(parent)
//    try validator(parent).validate(value)
//  }
//
//}

