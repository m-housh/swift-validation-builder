/// Validates a child value. Generally used when creating a validation for a nested value.
///
/// ** Example**
/// ```swift
/// struct User: Validatable {
///   let name: String
///   let email: String
///
///   var body: some Validator<Self> {
///     Validation {
///       Validate(\.name, using: NotEmtpy())
///       Validate(\.email) {
///         NotEmpty()
///         Contains("@")
///       }
///     }
///   }
/// }
/// try User(name: "Blob", email: "blob@example.com").validate() // success.
/// try User(name: "", email: "blob@example.com").validate() // fails.
///
/// ```
///
/// It can also be used with only a `KeyPath` when the value is `Validatable`
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
public struct Validate<Parent, Child>: Validation {

  @usableFromInline
  let child: (Parent) -> Child

  @usableFromInline
  let validator: (Parent) -> any Validation<Child>

  @usableFromInline
  init(
    _ child: @escaping (Parent) -> Child,
    validator: @escaping (Parent) -> any Validation<Child>
  ) {
    self.child = child
    self.validator = validator
  }
  
  @usableFromInline
  init(
    _ child: @escaping (Parent) -> Child,
    using validator: Validator<Child>
  ) {
    self.child = child
    self.validator = { _ in validator }
  }

  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>,
    @ValidationBuilder<Child> build: () -> any Validation<Child>
  ) {
    self.init(toChild, using: build())
  }

  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>,
    using validator: some Validation<Child>
  ) {
    self.init(
      toChild.value(from:),
      validator: { _ in validator }
    )
  }

  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>
  ) where Child: Validatable {
    self.init(toChild.value(from:), validator: toChild.value(from:))
  }

  @inlinable
  public func validate(_ parent: Parent) throws {
    let value = child(parent)
    try validator(parent).validate(value)
  }
}

extension Validators {
  // for discovery.
  public typealias Validate = Validations.Validate
}
