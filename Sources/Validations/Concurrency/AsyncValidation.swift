/// A type that can asynchronously validate a value or throw an error.  You can conform to this protocol by either
/// implementing the ``AsyncValidation/validate(_:)-158f4`` method, or by supplying a validator in the
/// ``AsyncValidation/body-swift.property-6k2b1`` property.
///
///  **Example using the `validate(_: Value)` implementatin.**
///  ```swift
///     struct AsyncAlways<Value>: AsyncValidation {
///        func validate(_ value: Value) async throws {
///         // do nothing
///        }
///     }
///  ```
///
///   **Example using the `body` property.**
///   ```swift
///   struct User {
///     let name: String
///     let email: String
///   }
///
///   struct BlobValidator: AsyncValidation {
///
///     typealias Value = User
///
///     var body: some AsyncValidation<User> {
///       AsyncValidator {
///         AsyncValidator.validate(\.name, with: .equals("Blob"))
///         AsyncValidator.validate(\.email, with: .equals("blob@example.com"))
///       }
///     }
///   }
///
///   let blob = User(name: "Blob", email: "blob@example.com")
///   let notBlob = User(name: "Blob Jr.", email: "blob.jr@example.com")
///
///   let validator = BlobValidator()
///
///   try await validator.validate(blob) // success.
///   try await validator.validate(notBlob) // throws.
///
///   ```
///
public protocol AsyncValidation<Value> {

  associatedtype Value

  associatedtype _Body

  typealias Body = _Body

  /// Validate the value or throw an error.
  ///
  /// - Parameters:
  ///   - value: The value to validate.
  func validate(_ value: Value) async throws

  /// Implement the validation using / building a validator using builder syntax.
  ///
  @AsyncValidationBuilder<Value>
  var body: Body { get }
}

extension AsyncValidation where Body == Swift.Never {

  @_transparent
  public var body: Body {
    fatalError("\(Self.self) has no body.")
  }
}

extension AsyncValidation where Body: AsyncValidation, Body.Value == Value {

  @inlinable
  public func validate(_ value: Value) async throws {
    try await self.body.validate(value)
  }
}
