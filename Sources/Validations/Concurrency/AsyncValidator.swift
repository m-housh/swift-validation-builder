/// A type that can asynchronously validate a value or throw an error.  You can conform to this protocol by either
/// implementing the ``AsyncValidator/validate(_:)-6qhpy`` method, or by supplying a validator in the
/// ``AsyncValidator/body-swift.property-44764`` property.
///
///  **Example using the `validate(_: Value)` implementatin.**
///  ```swift
///     struct AsyncAlways<Value>: AsyncValidator {
///        func validate(_ value: Value>) async throws {
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
///   struct BlobValidator: AsyncValidator {
///     var body: some AsyncValidator<User> {
///       AsyncValidation {
///         Equals(\.name, "Blob")
///         Equals(\.email, "blob@example.com")
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
public protocol AsyncValidator<Value> {

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
  /// - SeeAlso:
  ///   - ``AsyncValidator``
  @AsyncValidationBuilder<Value>
  var body: Body { get }
}

extension AsyncValidator where Body == Never {

  @_transparent
  public var body: Body {
    fatalError("\(Self.self) has no body.")
  }
}

extension AsyncValidator where Body: AsyncValidator, Body.Value == Value {

  @inlinable
  public func validate(_ value: Value) async throws {
    try await self.body.validate(value)
  }
}
