extension Validators {

  /// A ``Validation`` type that validates expressions that can be evaluated to `true` or `false`.
  ///
  /// This type does not need to be created directly, unless you need to customize the behavor based on
  /// the underlying state of the value during a call to it's ``BoolValidator/validate(_:)``.  In general
  /// you will often create this type through `Swift.Bool` type.
  ///
  /// **Example**
  /// ```
  /// struct User: Validation {
  ///   let name: String
  ///   let isAdmin: Bool
  ///
  ///   var body: some Validation<Self> {
  ///     Validate(\.name, using: String.notEmpty())
  ///   }
  /// }
  ///
  /// let adminUserValidator = ValidatorOf<User> {
  ///   Validate(\.self) // run default validations
  ///   Validate(\.isAdmin, using: true) // use the `Bool` type as the validator.
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
  public struct BoolValidator<Value>: Validation {

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

    @inlinable
    public func validate(_ value: Value) throws {
      let evaluated = evaluate(value)

      guard evaluated == bool else {
        throw ValidationError.failed(summary: "Failed bool evaluation, expected \(bool)")
      }
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

extension Bool: Validation {
  public typealias Value = Swift.Bool

  public var body: some Validation<Self> {
    self.validator()
  }

  /// Access a validator for a given `Swift.Bool`.
  ///
  /// ```swift
  /// let isTrueValidator = true.validator()
  /// ```
  @inlinable
  public func validator() -> Validators.BoolValidator<Self> {
    .init(expecting: self)
  }
}
