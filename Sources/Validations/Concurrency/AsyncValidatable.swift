/// Represents a type that can validate itself asynchronously.
///
/// ```swift
/// struct User {
///   let name: String
///   let email: String
/// }
///
/// extension User: AsyncValidatable {
///   var body: some AsyncValidation<Self> {
///     AsyncValidator {
///       Validators.validate(\.name, using: .notEmtpy())
///       Validators.validate(\.email, using: .email())
///     }
///   }
/// }
///
/// let blob = User(name: "Blob", email: "blob@example.com")
/// try await blob.validate() // success.
///
/// let invalid = User(name: "", email: "blob.jr@example.com")
/// try await invalid.validate() // error.
/// ```
///
public protocol AsyncValidatable: AsyncValidation where Value == Self {

  /// Validate an instance.
  func validate() async throws
}

extension AsyncValidatable where Self: AsyncValidation, Value == Self {

  @inlinable
  public func validate() async throws {
    try await self.validate(self)
  }
}
