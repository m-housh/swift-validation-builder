extension Validators {
  
  /// A validation that compares two elements.  This is generally not interacted with, but is
  /// made by one of the methods on the ``Validator`` type or the `Comparable`
  /// type that is being compared.
  ///
  /// **Example**
  /// ```
  ///  let intValidator = Int.lessThanOrEquals(10)
  ///
  ///  try intValidator.validate(10) // succeeds.
  ///  try intValidator.validate(11) // fails.
  /// ```
  ///
  public struct ComparableValidator<Value, Element>: Validation {
    @usableFromInline
    let lhs: (Value) -> Element
    
    @usableFromInline
    let rhs: (Value) -> Element
    
    @usableFromInline
    let `operator`: (Element, Element) -> Bool
    
    @usableFromInline
    let operatorString: String
    
    @inlinable
    public init(
      _ lhs: @escaping (Value) -> Element,
      _ rhs: @escaping (Value) -> Element,
      operator: @escaping (Element, Element) -> Bool,
      operatorString: String
      
    ) {
      self.lhs = lhs
      self.rhs = rhs
      self.operator = `operator`
      self.operatorString = operatorString
    }
    
    @inlinable
    public func validate(_ value: Value) throws {
      let lhs = self.lhs(value)
      let rhs = self.rhs(value)
      guard self.operator(lhs, rhs) else {
        throw ValidationError.failed(summary: "\(lhs) is not \(operatorString) \(rhs)")
      }
    }
    
  }
}
  
  /// Validates values are equal.
  ///
  ///
  /// **Example**
  /// ```swift
  /// let equalsTen = ValidatorOf<Int> {
  ///   Equals(10)
  /// }
  ///
  /// try equalsTen.validate(10) // success.
  /// try equalsTen.validate(11) // fails.
  ///```
  ///
//  public struct Equals<Value, Element: Equatable>: Validator {
//
//    @usableFromInline
//    let lhs: (Value) -> Element
//
//    @usableFromInline
//    let rhs: (Value) -> Element
//
//    /// Create an equals validator using closures.
//    ///
//    /// **Example**
//    /// ```swift
//    /// struct Deeply {
//    ///   let nested = Nested()
//    ///  struct Nested {
//    ///    let value = 10
//    ///  }
//    /// }
//    ///
//    /// struct Parent {
//    ///   let count: Int
//    ///   let deeply = Deeply()
//    /// }
//    ///
//    /// let countValidator = ValidatorOf<Parent> {
//    ///   Equals({ $0.count }, { $0.deeply.nested.value })
//    /// }
//    ///
//    /// try countValidator.validate(.init(count: 10)) // success.
//    /// try countValidator.validate(.init(count: 11)) // fails.
//    ///
//    /// ```
//    ///
//    @inlinable
//    public init(
//      _ lhs: @escaping (Value) -> Element,
//      _ rhs: @escaping (Value) -> Element
//    ) {
//      self.lhs = lhs
//      self.rhs = rhs
//    }
//
//    /// Create an equals validator using key paths.
//    ///
//    /// **Example**
//    /// ```swift
//    /// struct Deeply {
//    ///   let nested = Nested()
//    ///  struct Nested {
//    ///    let value = 10
//    ///  }
//    /// }
//    ///
//    /// struct Parent {
//    ///   let count: Int
//    ///   let deeply = Deeply()
//    /// }
//    ///
//    /// let countValidator = ValidatorOf<Parent> {
//    ///   Equals(\.count, \.deeply.nested.value)
//    /// }
//    ///
//    /// try countValidator.validate(.init(count: 10)) // success.
//    /// try countValidator.validate(.init(count: 11)) // fails.
//    ///
//    /// ```
//    ///
//    @inlinable
//    public init(
//      _ lhs: KeyPath<Value, Element>,
//      _ rhs: KeyPath<Value, Element>
//    ) {
//      self.init(lhs.value(from:), rhs.value(from:))
//    }
//
//    /// Create an equals validator using key path and a value.
//    ///
//    /// **Example**
//    /// ```swift
//    /// struct Parent {
//    ///   let count: Int
//    /// }
//    ///
//    /// let countValidator = ValidatorOf<Parent> {
//    ///   Equals(\.count, 10)
//    /// }
//    ///
//    /// try countValidator.validate(.init(count: 10)) // success.
//    /// try countValidator.validate(.init(count: 11)) // fails.
//    ///
//    /// ```
//    ///
//    @inlinable
//    public init(
//      _ lhs: KeyPath<Value, Element>,
//      _ rhs: Element
//    ) {
//      self.init(lhs.value(from:), { _ in rhs })
//    }
//
//    public var body: some Validator<Value> {
//      ComparableValidator(lhs, rhs, operator: { $0 == $1 }, operatorString: "equal")
//    }
//
////    @inlinable
////    public func validate(_ value: Value) throws {
////      let lhs = self.lhs(value)
////      let rhs = self.rhs(value)
////
////      guard lhs == rhs else {
////        throw ValidationError.failed(summary: "\(lhs) is not equal to \(rhs)")
////      }
////    }
//
//  }
//}

//extension Validators.Equals where Value == Element {
//
//  /// Create an equals validator using  a value.
//  ///
//  /// **Example**
//  /// ```swift
//  /// let countValidator = ValidatorOf<Int> {
//  ///   Equals(10)
//  /// }
//  ///
//  /// try countValidator.validate(10) // success.
//  /// try countValidator.validate(11) // fails.
//  ///
//  /// ```
//  ///
//  @inlinable
//  public init(_ rhs: Element) {
//    self.init(\.self, rhs)
//  }
//}
//
//public typealias Equals = Validators.Equals

// MARK: - Equatable

extension Validator {
  
  /// Validates two elements are equal, using closures to access the elements.
  ///
  /// **Example**
  ///```swift
  /// struct Deeply {
  ///   let nested = Nested()
  ///  struct Nested {
  ///    let value = 10
  ///  }
  /// }
  ///
  /// struct Example {
  ///   let count: Int
  ///   let deeply: Deeply = Deeply()
  /// }
  ///
  /// let validator = ValidatorOf<Example>.equals({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try validator.validate(.init(count: 10)) // succeeds.
  /// try validatore.valiate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  public static func equals<Element: Equatable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping  (Value) -> Element
  ) -> Self {
    self.init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 == $1 },
        operatorString: "equal to"
      )
    )
  }
}

//extension Validator where Value: Collection, Value.Element: Equatable {
  
//  @inlinable
//  public static func equals(
//    _ lhs: KeyPath<Value, Value.Element>,
//    _ rhs: KeyPath<Value, Value.Element>
//  ) -> Self {
//    .equals(lhs.value(from:), rhs.value(from:))
//  }
  
//  @inlinable
//  public static func equals(
//    _ lhs: KeyPath<Value, Value.Element>,
//    _ rhs: Value.Element
//  ) -> Self {
//    .equals(lhs.value(from:), { _ in rhs })
//  }
//}

//extension Validator where Value: Collection, Value.Element: Equatable, Value == Value.Element {
//
//  @inlinable
//  public static func equals(
//    _ rhs: Value.Element
//  ) -> Self {
//    .equals(\.self, rhs)
//  }
//}

extension Validator where Value: Equatable {
  
  @inlinable
  public static func equals(
    _ rhs: Value
  ) -> Self {
    .equals({ $0 }, { _ in rhs })
  }
}

extension Equatable {
 
  static func equals(_ rhs: Self) -> some Validation<Self> {
    Validator.equals(rhs)
  }
  
  func equalsValidator() -> some Validation<Self> {
    Self.equals(self)
  }
}

// MARK: - Greater Than
extension Validator {
  
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(Validators.ComparableValidator(
      lhs,
      rhs,
      operator: { $0 > $1 },
      operatorString: "greater than")
    )
  }
  
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThan(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    greaterThan(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThan({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(Validators.ComparableValidator(
      lhs,
      rhs,
      operator: { $0 >= $1 },
      operatorString: "greater than or equal to")
    )
  }
  
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThanOrEquals(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    greaterThanOrEquals(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
}

extension Validator where Value: Comparable {
  
  @inlinable
  public static func greaterThan(_ rhs: Value) -> Self {
    greaterThan(\.self, rhs)
  }
  
//  @inlinable
//  public static func greaterThan(
//    _ rhs: KeyPath<Value, Value>
//  ) -> Self {
//    greaterThan(\.self, rhs)
//  }
  
  @inlinable
  public static func greaterThanOrEquals(_ rhs: Value) -> Self {
    greaterThanOrEquals(\.self, rhs)
  }
  
//  @inlinable
//  public static func greaterThanOrEquals(
//    _ rhs: KeyPath<Value, Value>
//  ) -> Self {
//    greaterThanOrEquals(\.self, rhs)
//  }
  
}

extension Comparable {
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validation<Value> {
    Validator<Value>.greaterThan(lhs, rhs)
  }
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    greaterThan(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validation<Value> {
    greaterThan(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    greaterThan({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThan(_ other: Self) -> some Validation<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public static func greaterThan(_ other: KeyPath<Self, Self>) -> some Validation<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public func greaterThanValidator() -> some Validation<Self> {
    Self.greaterThan(self)
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validation<Value> {
    Validator<Value>.greaterThanOrEquals(lhs, rhs)
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    greaterThanOrEquals(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validation<Value> {
    greaterThanOrEquals(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    greaterThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThanOrEquals(_ other: Self) -> some Validation<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public static func greaterThanOrEquals(_ other: KeyPath<Self, Self>) -> some Validation<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public func greaterThanOrEqualsValidator() -> some Validation<Self> {
    Self.greaterThan(self)
  }
}

// MARK: - Less Than

extension Validator {
  
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(Validators.ComparableValidator(
      lhs,
      rhs,
      operator: { $0 < $1 },
      operatorString: "less than")
    )
  }
  
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThan(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    lessThan(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThan({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(Validators.ComparableValidator(
      lhs,
      rhs,
      operator: { $0 <= $1 },
      operatorString: "less than or equal to")
    )
  }
  
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThanOrEquals(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    lessThanOrEquals(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
}

extension Validator where Value: Comparable {
  
  @inlinable
  public static func lessThan(_ rhs: Value) -> Self {
    lessThan(\.self, rhs)
  }
  
  @inlinable
  public static func lessThan(
    _ rhs: KeyPath<Value, Value>
  ) -> Self {
    lessThan(\.self, rhs)
  }
  
  @inlinable
  public static func lessThanOrEquals(_ rhs: Value) -> Self {
    lessThanOrEquals(\.self, rhs)
  }
  
  @inlinable
  public static func lessThanOrEquals(
    _ rhs: KeyPath<Value, Value>
  ) -> Self {
    lessThanOrEquals(\.self, rhs)
  }
  
}

extension Comparable {
  
  @inlinable
  public static func lessThan<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validation<Value> {
    Validator<Value>.lessThan(lhs, rhs)
  }
  
  @inlinable
  public static func lessThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    lessThan(lhs.value(from:), rhs.value(from:))
  }
  @inlinable
  public static func lessThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validation<Value> {
    lessThan(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func lessThan<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    lessThan({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func lessThan(_ other: Self) -> some Validation<Self> {
    lessThan(\.self, other)
  }
  
  @inlinable
  public static func lessThan(_ other: KeyPath<Self, Self>) -> some Validation<Self> {
    lessThan(\.self, other)
  }
  
  @inlinable
  public func lessThanValidator() -> some Validation<Self> {
    Self.lessThan(self)
  }
  
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validation<Value> {
    Validator<Value>.lessThanOrEquals(lhs, rhs)
  }
  
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    lessThanOrEquals(lhs.value(from:), rhs.value(from:))
  }
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validation<Value> {
    lessThanOrEquals(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validation<Value> {
    lessThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func lessThanOrEquals(_ other: Self) -> some Validation<Self> {
    lessThanOrEquals(\.self, other)
  }
  
  @inlinable
  public static func lessThanOrEquals(_ other: KeyPath<Self, Self>) -> some Validation<Self> {
    lessThanOrEquals(\.self, other)
  }
  
  @inlinable
  public func lessThanOrEqualsValidator() -> some Validation<Self> {
    Self.lessThanOrEquals(self)
  }
}

