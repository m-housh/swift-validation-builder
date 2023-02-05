/// Represents a type that can validate itself.
///
/// ```swift
/// struct User {
///   let name: String
///   let email: String
/// }
///
/// extension User: Validatable {
///   var body: some Validation<Self> {
///     Validation {
///       Validators.validate(\.name, with: String.notEmpty())
///       Validators.validate(\.email, with: String.notEmpty())
///     }
///   }
/// }
///
/// let blob = User(name: "Blob", email: "blob@example.com")
/// try blob.validate() // success.
///
/// let invalid = User(name: "", email: "blob.jr@example.com")
/// try invalid.validate() // error.
/// ```
///
public protocol Validatable: Validation where Value == Self {

  /// Validate an instance.
  func validate() throws
}

extension Validatable {

  @inlinable
  public func validate() throws {
    try self.validate(self)
  }
}
