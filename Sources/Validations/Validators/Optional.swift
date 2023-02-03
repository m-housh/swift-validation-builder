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
  public func `optional`() -> Validators.Optional<Self> {
    Validators.Optional(self)
  }

  /// Transform a ``Validation`` to one that works on an optional.
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
  public func map<V>(
    _ downstream: @escaping () -> some Validation<V>
  ) -> some Validation<V?>
  where Self.Value == V? {
    self.map { downstream().optional() }
  }
}

extension Validators {

  /// A ``Validation`` that runs a validator if the value is not nil.
  ///
  /// This type is generally not interacted with directly, instead you call the``Validation/optional()`` method
  /// on an existing validator.
  ///
  public struct Optional<Downstream: Validation>: Validation {

    public typealias Value = Downstream.Value?

    public let downstream: Downstream

    /// Create a new ``Validators/Optional`` with the given downstream validator to be called when
    /// values are not nil.
    ///
    /// - Parameters:
    ///   - validator: The validator to use when values are not nil.
    ///
    @inlinable
    public init(_ validator: Downstream) {
      self.downstream = validator
    }

    @inlinable
    public func validate(_ value: Downstream.Value?) throws {
      guard let unwrapped = value.wrappedValue else {
        return
      }
      try downstream.validate(unwrapped)
    }
  }

  /// A ``Validation`` that validates optional values are not nil
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = Validators.NotNil<Int?>()
  ///
  /// try validator.validate(.some(1)) // success.
  /// try validator.validate(.none)) // fails.
  /// ```
  ///
  public struct NotNil<Value: _AnyOptional>: Validation {

    @inlinable
    public init() {}

    @inlinable
    public func validate(_ value: Value) throws {
      guard let _ = value.wrappedValue else {
        throw ValidationError.failed(summary: "Expected to not be nil")
      }
    }
  }

  /// A ``Validation`` that validates optional values are nil
  ///
  /// **Example**
  ///
  ///```swift
  /// let validator = Validators.Nil<Int?>()
  ///
  /// try validator.validate(.none)) // success.
  /// try validator.validate(.some(1)) // fails.
  /// ```
  ///
  public struct Nil<Value: _AnyOptional>: Validation {

    @inlinable
    public init() {}

    public var body: some Validation<Value> {
      Not(NotNil())
        .mapError(ValidationError.failed(summary: "Expected nil"))
    }
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
    .init(Validators.Nil<Value>())
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
    .init(Validators.NotNil())
  }
}

extension Optional: Validation where Wrapped: Validation {

  @inlinable
  public func validate(_ value: Wrapped.Value) throws {
    if let validator = self {
      try validator.validate(value)
    }
  }
}

extension Optional: AsyncValidation where Wrapped: AsyncValidation {

  @inlinable
  public func validate(_ value: Wrapped.Value) async throws {
    if let validator = self {
      try await validator.validate(value)
    }
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
