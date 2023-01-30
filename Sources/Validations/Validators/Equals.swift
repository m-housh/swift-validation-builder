/// Validates values are equal.
///
/// **Example**
/// ```
/// let equalsTen = ValidatorOf<Int> {
///   Equals(10)
/// }
///
/// try equalsTen.validate(10) // success.
/// try equalsTen.validate(11) // fails.
///```
///
public struct Equals<Value, Element: Equatable>: Validator {
  
  @usableFromInline
  let lhs: (Value) -> Element
  
  @usableFromInline
  let rhs: (Value) -> Element
  
  /// Create an equals validator using closures.
  ///
  /// **Example**
  /// ```
  /// struct Deeply {
  ///   let nested = Nested()
  ///  struct Nested {
  ///    let value = 10
  ///  }
  /// }
  ///
  /// struct Parent {
  ///   let count: Int
  ///   let deeply = Deeply()
  /// }
  ///
  /// let countValidator = ValidatorOf<Parent> {
  ///   Equals({ $0.count}, { $0.deeply.nested.value })
  /// }
  ///
  /// try countValidator.validate(.init(count: 10)) // success.
  /// try countValidator.validate(.init(count: 11)) // fails.
  ///
  /// ```
  ///
  @inlinable
  public init(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) {
    self.lhs = lhs
    self.rhs = rhs
  }
  
  /// Create an equals validator using key paths.
  ///
  /// **Example**
  /// ```
  /// struct Deeply {
  ///   let nested = Nested()
  ///  struct Nested {
  ///    let value = 10
  ///  }
  /// }
  ///
  /// struct Parent {
  ///   let count: Int
  ///   let deeply = Deeply()
  /// }
  ///
  /// let countValidator = ValidatorOf<Parent> {
  ///   Equals(\.count, \.deeply.nested.value)
  /// }
  ///
  /// try countValidator.validate(.init(count: 10)) // success.
  /// try countValidator.validate(.init(count: 11)) // fails.
  ///
  /// ```
  ///
  @inlinable
  public init(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) {
    self.init(lhs.value(from:), rhs.value(from:))
  }
  
  /// Create an equals validator using key path and a value.
  ///
  /// **Example**
  /// ```
  /// struct Parent {
  ///   let count: Int
  /// }
  ///
  /// let countValidator = ValidatorOf<Parent> {
  ///   Equals(\.count, 10)
  /// }
  ///
  /// try countValidator.validate(.init(count: 10)) // success.
  /// try countValidator.validate(.init(count: 11)) // fails.
  ///
  /// ```
  ///
  @inlinable
  public init(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) {
    self.init(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public func validate(_ value: Value) throws {
    let lhs = self.lhs(value)
    let rhs = self.rhs(value)
    
    guard lhs == rhs else {
      throw ValidationError(message: "\(lhs) is not equal to \(rhs)")
    }
  }
  
}

extension Equals where Value == Element {
  
  /// Create an equals validator using  a value.
  ///
  /// **Example**
  /// ```
  /// let countValidator = ValidatorOf<Int> {
  ///   Equals(10)
  /// }
  ///
  /// try countValidator.validate(10) // success.
  /// try countValidator.validate(11) // fails.
  ///
  /// ```
  ///
  @inlinable
  public init(_ rhs: Element) {
    self.init(\.self, rhs)
  }
}

