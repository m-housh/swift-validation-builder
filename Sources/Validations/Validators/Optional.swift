import CasePaths

extension Validation {

  /// Transforms a ``Validation`` to one that works on an optional.
  ///
  /// The validator only gets called when the value is not nil.
  ///
  /// ```swift
  /// let validator = Int.greaterThan(10).optional()
  ///
  /// try validator.validate(.none) // success.
  /// try validator.validate(.some(11)) // success.
  /// try validator.validate(.some(9)) // fails.
  /// ```
  ///
  @inlinable
  public func `optional`() -> Validators.OptionalValidator<Self, Value?> {
    Validators.OptionalValidator(self)
  }

  /// Transform a ``Validation`` to one that works on an optional and fails if
  /// the value is `nil`
  ///
  /// ```swift
  /// let validator = ValidatorOf<Int?>.notNil().map {
  ///   Int.greaterThan(10)
  /// }
  ///
  /// try validator.validate(.some(11)) // success.
  /// try validator.validate(.some(9)) // fails.
  /// try validator.validate(.none) // fails.
  ///
  /// ```
  @inlinable
  public func map<Downstream: Validation>(
    _ downstream: @escaping () -> Downstream
  ) -> Validators.MapOptional<Downstream, Value>
  where Value: _AnyOptional, Value.WrappedValue == Downstream.Value {
    .init(downstream())
  }
}

extension AsyncValidation {

  /// Transforms a ``AsyncValidation`` to one that works on an optional.
  ///
  /// The validator only gets called when the value is not nil.
  ///
  /// ```swift
  /// let validator = Int.greaterThan(10).optional()
  ///
  /// try validator.validate(.none) // success.
  /// try validator.validate(.some(11)) // success.
  /// try validator.validate(.some(9)) // fails.
  /// ```
  ///
  @inlinable
  public func `optional`() -> Validators.OptionalValidator<Self, Value?> {
    Validators.OptionalValidator(self)
  }

  /// Transform an``AsyncValidation`` to one that works on an optional and fails
  /// validation if the optional value is `nil`.
  ///
  /// ```swift
  /// let validator = AsyncValidatorOf<Int?>.notNil().map {
  ///   Int.greaterThan(10).async
  /// }
  ///
  /// try await validator.validate(.some(11)) // success.
  /// try await validator.validate(.some(9)) // fails.
  /// try await validator.validate(.none) // fails.
  ///
  /// ```
  @inlinable
  public func map<Downstream: AsyncValidation>(
    _ downstream: @escaping () -> Downstream
  ) -> Validators.MapOptional<Downstream, Value>
  where Value: _AnyOptional, Value.WrappedValue == Downstream.Value {
    .init(downstream())
  }
}

extension Validators {

  /// A type that maps on an optional value, throwing errors if the value is `nil`.
  ///
  /// This type is generally not interacted with directly, instead you cal ``Validation/map(_:)-56k9d`` on
  /// an existing ``Validation`` or ``AsyncValidation``
  ///
  /// ```swift
  /// let validator = ValidatorOf<Int?>.notNil().map {
  ///   Int.greaterThan(10)
  /// }
  ///
  /// try validator.validate(.some(11)) // success.
  /// try validator.validate(.some(9)) // fails.
  /// try validator.validate(.none) // fails.
  ///
  /// ```
  ///
  public struct MapOptional<Downstream, Value> {

    public let downstream: Downstream

    @inlinable
    public init(_ downstream: Downstream) {
      self.downstream = downstream
    }
  }

  /// A validation that runs a validator if the value is not nil.
  ///
  /// This type is generally not interacted with directly, instead you call the ``Validation/optional()`` method
  /// on an existing validator.
  ///
  /// ```swift
  /// let validator = Int.greaterThan(10).optional()
  ///
  /// try validator.validate(.none) // success.
  /// try validator.validate(.some(11)) // success.
  /// try validator.validate(.some(9)) // fails.
  /// ```
  ///
  public struct OptionalValidator<Upstream, Value> {

    public let upstream: Upstream

    /// Create a new ``Validators/OptionalValidator`` with the given downstream validator to be called when
    /// values are not nil.
    ///
    /// - Parameters:
    ///   - validator: The validator to use when values are not nil.
    ///
    @inlinable
    public init(_ validator: Upstream) {
      self.upstream = validator
    }

  }

  /// A validation that validates optional values are not nil
  ///
  /// This type is not interacted with directly, instead use one of the methods such as ``Validator/notNil()`` and
  /// ``AsyncValidator/notNil()``
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = ValidatorOf<Int?>.notNil()
  ///
  /// try validator.validate(.some(1)) // success.
  /// try validator.validate(.none)) // fails.
  /// ```
  ///
  public struct NotNilValidator<Value: _AnyOptional, Upstream> {
    @inlinable
    public init() {}
  }

  /// A validation that validates optional values are nil
  ///
  /// This type is not interacted with directly, instead use one of the methods such as ``Validator/nil()`` and
  /// ``AsyncValidator/nil()``
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = ValidatorOf<Int?>.nil()
  ///
  /// try validator.validate(.none)) // success.
  /// try validator.validate(.some(1)) // fails.
  /// ```
  ///
  public struct NilValidator<Value: _AnyOptional, Upstream> {

    @inlinable
    public init() {}

  }
}

extension Validator where Value: _AnyOptional {

  /// A ``Validator`` that validates optional values are nil
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = ValidatorOf<Int?>.nil()
  ///
  /// try validator.validate(.none)) // success.
  /// try validator.validate(.some(1)) // fails.
  /// ```
  ///
  @inlinable
  public static func `nil`() -> Self {
    .init(Validators.NilValidator<Value, Self>())
  }

  /// A ``Validation`` that validates optional values are not nil
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = ValidatorOf<Int?>.notNil()
  ///
  /// try validator.validate(.some(1)) // success.
  /// try validator.validate(.none)) // fails.
  /// ```
  ///
  @inlinable
  public static func notNil() -> Self {
    .init(Validators.NotNilValidator<Value, Self>())
  }
}

extension AsyncValidator where Value: _AnyOptional {

  /// An ``AsyncValidator`` that validates optional values are nil
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = AsyncValidatorOf<Int?>.nil()
  ///
  /// try validator.validate(.none)) // success.
  /// try validator.validate(.some(1)) // fails.
  /// ```
  ///
  @inlinable
  public static func `nil`() -> Self {
    .init(Validators.NilValidator<Value, Self>())
  }

  /// An``AsyncValidator`` that validates optional values are not nil
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = ValidatorOf<Int?>.notNil()
  ///
  /// try validator.validate(.some(1)) // success.
  /// try validator.validate(.none)) // fails.
  /// ```
  ///
  @inlinable
  public static func notNil() -> Self {
    .init(Validators.NotNilValidator<Value, Self>())
  }
}

/// Helper type used for extensions on ``Validator`` for creating optional validations.
///
public protocol _AnyOptional {
  associatedtype WrappedValue
  var wrappedValue: WrappedValue? { get }
}

extension Optional: _AnyOptional {

  public typealias WrappedValue = Self.Wrapped

  public var wrappedValue: Self.Wrapped? {
    switch self {
    case let .some(wrapped):
      return wrapped
    case .none:
      return nil
    }
  }
}

extension Validators.OptionalValidator: Validation
where
  Upstream: Validation,
  Value: _AnyOptional,
  Upstream.Value == Value.WrappedValue
{

  @inlinable
  public func validate(_ value: Value) throws {
    guard let unwrapped = value.wrappedValue else {
      return
    }
    try upstream.validate(unwrapped)
  }

}

extension Validators.MapOptional: Validation
where
  Downstream: Validation,
  Value: _AnyOptional,
  Downstream.Value == Value.WrappedValue
{

  @inlinable
  public func validate(_ value: Value) throws {
    guard let unwrapped = value.wrappedValue else {
      throw ValidationError.failed(summary: "Expected not nil.")
    }
    try downstream.validate(unwrapped)
  }

}

extension Validators.OptionalValidator: AsyncValidation
where
  Upstream: AsyncValidation,
  Value: _AnyOptional,
  Upstream.Value == Value.WrappedValue
{

  @inlinable
  public func validate(_ value: Value) async throws {
    guard let unwrapped = value.wrappedValue else {
      return
    }
    try await upstream.validate(unwrapped)
  }

}

extension Validators.MapOptional: AsyncValidation
where
  Downstream: AsyncValidation,
  Value: _AnyOptional,
  Downstream.Value == Value.WrappedValue
{

  @inlinable
  public func validate(_ value: Value) async throws {
    guard let unwrapped = value.wrappedValue else {
      throw ValidationError.failed(summary: "Expected to not be nil.")
    }
    try await downstream.validate(unwrapped)
  }

}

extension Validators.NotNilValidator: Validation where Upstream: Validation {
  @inlinable
  public func validate(_ value: Value) throws {
    guard let _ = value.wrappedValue else {
      throw ValidationError.failed(summary: "Expected to not be nil.")
    }
  }
}

extension Validators.NotNilValidator: AsyncValidation where Upstream: AsyncValidation {
  @inlinable
  public func validate(_ value: Value) throws {
    guard let _ = value.wrappedValue else {
      throw ValidationError.failed(summary: "Expected to not be nil.")
    }
  }
}

extension Validators.NilValidator: Validation where Upstream: Validation {

  @inlinable
  public func validate(_ value: Value) throws {
    guard case .none = value.wrappedValue else {
      throw ValidationError.failed(summary: "Expected nil.")
    }
  }
}

extension Validators.NilValidator: AsyncValidation where Upstream: AsyncValidation {

  @inlinable
  public func validate(_ value: Value) async throws {
    guard case .none = value.wrappedValue else {
      throw ValidationError.failed(summary: "Expected nil.")
    }
  }
}
