/// Represents a type that can validate itself asynchronously.
///
/// ```swift
/// struct User {
///   let name: String
///   let email: String
/// }
///
/// extension User: AsyncValidatable {
///   var body: some AsyncValidator<Self> {
///     AsyncValidation {
///       Not(Equals(\.name, ""))
///       Not(Equals(\.email, ""))
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
public protocol AsyncValidatable: AsyncValidator where Value == Self {

  /// Validate an instance.
  func validate() async throws
}

extension AsyncValidatable where Self: AsyncValidator, Value == Self {

  @inlinable
  public func validate() async throws {
    try await self.validate(self)
  }
}
