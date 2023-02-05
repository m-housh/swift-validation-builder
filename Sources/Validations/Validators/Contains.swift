extension Validators {
  /// A ``Validation`` for if a collection contains a value.
  ///
  /// ```swift
  /// let validator = ValidatorOf<String> {
  ///   Validator.contains("@")
  ///   // or String.contains("@") could be used.
  /// }
  ///
  /// try validator.validate("blob@example.com") // success.
  /// try validator.validate("blob.jr.example.com") // fails.
  ///
  /// ```
  ///
  public struct Contains<Value: Collection> {

    public let element: Value.Element

    @inlinable
    public init(element: Value.Element) {
      self.element = element
    }

  }
}

extension Validators.Contains: Validation
where
  Value.Element: Equatable
{

  @usableFromInline
  func _validate(_ value: Value) throws {
    guard value.contains(element) else {
      throw ValidationError.failed(summary: "Does not contain \(element)")
    }
  }

  @inlinable
  public func validate(_ value: Value) throws {
    try _validate(value)
  }

}

extension Validator {
  /// A ``Validation`` for if a `Collection` contains a value.
  ///
  /// Use this validator, when you need to validate a collection and value that is accessed by a `KeyPath` from
  /// the parent context.
  ///
  /// ```swift
  /// struct MatchCharacter: Validatable {
  ///   let input: String
  ///   let character: Character
  ///
  ///   var body: some Validation<Self> {
  ///     Validator.contains(\.input, \.character)
  ///   }
  /// }
  ///
  ///
  /// try MatchWord(input: "blob around the world", character: "a").validate() // success.
  /// try MatchWord(input: "blob jr.", character: "z").validate() // fails.
  ///
  /// ```
  ///
  @inlinable
  public static func contains<C: Collection>(
    _ toCollection: KeyPath<Value, C>,
    _ toElement: KeyPath<Value, C.Element>
  ) -> Self
  where C.Element: Equatable {
    .init(
      Self.lazy { parent in
        Validator.validate(toCollection) {
          C.contains(parent[keyPath: toElement])
        }
      }
    )
  }

  /// A ``Validation`` for if a `Collection` contains a value.
  ///
  /// Use this validator, when you need to validate a collection that is accessed by a `KeyPath` from
  /// the parent context, using the given element for the value to look for.
  ///
  /// ```swift
  /// struct MatchCharacter: Validatable {
  ///   let input: String
  ///   let character: Character
  ///
  ///   var body: some Validation<Self> {
  ///     Validator.contains(\.input, \.character)
  ///   }
  /// }
  ///
  /// let containsZ = ValidatorOf<MatchCharacter>.contains(\.input, "z")
  ///
  /// try containsZ.validate(.init(input: "baz", character: "f")) // success.
  /// try containsZ.validate(.init(input: "foo", character: "f")) // fails.
  ///
  /// ```
  @inlinable
  public static func contains<C: Collection>(
    _ toCollection: KeyPath<Value, C>,
    _ element: C.Element
  ) -> Self
  where C.Element: Equatable {
    .init(
      Validator.validate(toCollection) {
        C.contains(element)
      }
    )
  }
}

extension Validator where Value: Collection, Value.Element: Equatable {

  /// Create a ``Validator`` that validates a `Collection` contains an element.
  ///
  /// ```swift
  /// let hasOneValidator = ValidatorOf<[Int]>.contains(1)
  ///
  /// try hasOneValidator.validate([2, 3, 6, 4, 1]) // success.
  /// try hasOneValidator.validate([4, 9, 7, 3]) // fails
  ///
  /// ```
  ///
  @inlinable
  public static func contains(_ element: Value.Element) -> Self {
    .init(Value.contains(element))
  }
}

extension Collection where Element: Equatable {

  /// Create a ``Validators/Contains`` from a `Collection` type.
  ///
  /// This primarily used when inside one of the result builder contexts, such as a``ValidationBuilder``.
  ///
  /// >  Note: When not inside of a validation builder  context you will need
  /// >  to mark your validator's type, to get a ``Validator``.
  /// > `let validator: Validator<String> = String.contains("@")`.
  ///
  ///
  /// - Parameters:
  ///   - element: The element to validate is in the collection.
  @inlinable
  public static func contains(_ element: Element) -> Validators.Contains<Self> {
    .init(element: element)
  }
}

// MARK: - Async
extension AsyncValidator {
  /// An ``AsyncValidation`` for if a `Collection` contains a value.
  ///
  /// Use this validator, when you need to validate a collection and value that is accessed by a `KeyPath` from
  /// the parent context.
  ///
  /// ```swift
  /// struct MatchCharacter: AsyncValidatable {
  ///   let input: String
  ///   let character: Character
  ///
  ///   var body: some AsyncValidation<Self> {
  ///     AsyncValidator.contains(\.input, \.character)
  ///   }
  /// }
  ///
  ///
  /// try await MatchWord(input: "blob around the world", character: "a").validate() // success.
  /// try await MatchWord(input: "blob jr.", character: "z").validate() // fails.
  ///
  /// ```
  ///
  @inlinable
  public static func contains<C: Collection>(
    _ toCollection: KeyPath<Value, C>,
    _ toElement: KeyPath<Value, C.Element>
  ) -> Self
  where C.Element: Equatable {
    .init(
      Validator.contains(toCollection, toElement).async
    )
  }

  /// An ``AsyncValidation`` for if a `Collection` contains a value.
  ///
  /// Use this validator, when you need to validate a collection that is accessed by a `KeyPath` from
  /// the parent context, using the given element for the value to look for.
  ///
  /// ```swift
  /// struct MatchCharacter: AsyncValidatable {
  ///   let input: String
  ///   let character: Character
  ///
  ///   var body: some AsyncValidation<Self> {
  ///     AsyncValidator.contains(\.input, \.character)
  ///   }
  /// }
  ///
  /// let containsZ = AsyncValidatorOf<MatchCharacter>.contains(\.input, "z")
  ///
  /// try await containsZ.validate(.init(input: "baz", character: "f")) // success.
  /// try await containsZ.validate(.init(input: "foo", character: "f")) // fails.
  ///
  /// ```
  @inlinable
  public static func contains<C: Collection>(
    _ toCollection: KeyPath<Value, C>,
    _ element: C.Element
  ) -> Self
  where C.Element: Equatable {
    .init(
      Validator.contains(toCollection, element).async
    )
  }
}
