extension Validator where Value == Bool {

  /// Create a ``Validator`` that validates a bool matches the given bool.
  ///
  /// ```swift
  ///   let validator = ValidatorOf<Bool>.bool(expecting: true)
  ///
  ///   try validator.validate(true) // succeeds.
  ///   try validator.validate(false) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - expecting: The bool to match during validations.
  @inlinable
  public static func bool(expecting: Value) -> Self {
    .init(Validators.BoolValidator<Self, Bool>(expecting: expecting))
  }
}

extension AsyncValidator where Value == Bool {

  /// Create an ``AsyncValidator`` that validates a bool matches the given bool.
  ///
  /// ```swift
  ///   let validator = AsyncValidatorOf<Bool>.bool(expecting: true)
  ///
  ///   try validator.validate(true) // succeeds.
  ///   try validator.validate(false) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - expecting: The bool to match during validations.
  @inlinable
  public static func bool(expecting: Value) -> Self {
    .init(Validators.BoolValidator<Self, Bool>(expecting: expecting))
  }
}

extension Validators {

  /// A ``Validation`` type that validates expressions that can be evaluated to `true` or `false`.
  ///
  /// This type is generally not interacted with directly, instead you create it with one of the static methods on
  /// an ``AsyncValidator`` or ``Validator``, or by using a `Swift.Bool` directly.
  ///
  /// **Example**
  ///
  /// ```swift
  /// struct User: Validation {
  ///   let name: String
  ///   let isAdmin: Bool
  ///
  ///   var body: some Validation<Self> {
  ///     validate(\.name, using: String.notEmpty())
  ///   }
  /// }
  ///
  /// let adminUserValidator = ValidatorOf<User> {
  ///   validate(\.self) // run default validations
  ///   validate(\.isAdmin, using: true) // use the `Bool` type as the validator.
  /// }
  ///
  /// let adminUser = User(name: "Blob", isAdmin: true)
  /// let nonAdminUser = User(name: "Blob Jr.", isAdmin: false)
  ///
  /// try adminUserValidator.validate(adminUser) // succeeds.
  /// try adminUserValidator.validate(nonAdminUser) // fails.
  ///
  /// try adminUser.validate() // succeeds defaults.
  /// try nonAdminUser.validate() // succeeds defaults.
  ///
  /// ```
  ///
  public struct BoolValidator<ValidationType, Value> {

    @usableFromInline
    let evaluate: (Value) -> Bool

    @usableFromInline
    let bool: Swift.Bool

    /// Create a bool validation using a custom evaluation to pass or fail validations.
    ///
    /// - Parameters:
    ///   - bool: What we are expecting when evaluating the expression.
    ///   - evaluate: The custom expression to use.
    ///
    @inlinable
    public init(
      expecting bool: Bool,
      evaluate: @escaping (Value) -> Bool
    ) {
      self.evaluate = evaluate
      self.bool = bool
    }
  }
}

extension Validators.BoolValidator: Validation where ValidationType: Validation {
  @inlinable
  public func validate(_ value: Value) throws {
    let evaluated = evaluate(value)

    guard evaluated == bool else {
      throw ValidationError.failed(summary: "Failed bool evaluation, expected \(bool)")
    }
  }
}

extension Validators.BoolValidator: AsyncValidation where ValidationType: AsyncValidation {

  @inlinable
  public func validate(_ value: Value) async throws {
    let evaluated = evaluate(value)

    guard evaluated == bool else {
      throw ValidationError.failed(summary: "Failed bool evaluation, expected \(bool)")
    }
  }
}

extension Validators.BoolValidator where Value == Bool {

  /// Create a ``Validators/BoolValidator`` expecting the given bool.
  ///
  /// - Parameters:
  ///   - expecting: The bool that we are expecting in order to pass validations.
  ///
  @inlinable
  public init(expecting bool: Bool) {
    self.init(expecting: bool, evaluate: { $0 })
  }
}
