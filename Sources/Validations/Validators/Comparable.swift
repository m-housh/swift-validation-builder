extension Validators {
  
  public struct ComparableValidator<Value, Element>: Validator {
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
    
    public func validate(_ value: Value) throws {
      let lhs = self.lhs(value)
      let rhs = self.rhs(value)
      guard self.operator(lhs, rhs) else {
        throw ValidationError.failed(summary: "\(lhs) is not \(operatorString) \(rhs)") // fix error.
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

extension Validation {
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

extension Validation where Value: Collection, Value.Element: Equatable {
  
  @inlinable
  public static func equals(
    _ lhs: KeyPath<Value, Value.Element>,
    _ rhs: KeyPath<Value, Value.Element>
  ) -> Self {
    .equals(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func equals(
    _ lhs: KeyPath<Value, Value.Element>,
    _ rhs: Value.Element
  ) -> Self {
    .equals(lhs.value(from:), { _ in rhs })
  }
}

extension Validation where Value: Collection, Value.Element: Equatable, Value == Value.Element {

  @inlinable
  public static func equals(
    _ rhs: Value.Element
  ) -> Self {
    .equals(\.self, rhs)
  }
}

extension Validation where Value: Equatable {
  
  @inlinable
  public static func equals(
    _ rhs: Value
  ) -> Self {
    .equals({ $0 }, { _ in rhs })
  }
}

extension Equatable {
  
//  static func equals(
//    _ lhs: Self,
//    _ rhs: Self
//  ) -> some Validator<Self> {
//    Validation.equals({ _ in lhs }, { _ in rhs })
//  }
  
  static func equals(_ rhs: Self) -> some Validator<Self> {
    Validation.equals(rhs)
  }
  
  func equalsValidator() -> some Validator<Self> {
    Self.equals(self)
  }
}

// MARK: - Greater Than
extension Validation {
  
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

extension Validation where Value: Comparable {
  
  @inlinable
  public static func greaterThan(_ rhs: Value) -> Self {
    greaterThan(\.self, rhs)
  }
  
  @inlinable
  public static func greaterThan(
    _ rhs: KeyPath<Value, Value>
  ) -> Self {
    greaterThan(\.self, rhs)
  }
  
  @inlinable
  public static func greaterThanOrEquals(_ rhs: Value) -> Self {
    greaterThanOrEquals(\.self, rhs)
  }
  
  @inlinable
  public static func greaterThanOrEquals(
    _ rhs: KeyPath<Value, Value>
  ) -> Self {
    greaterThanOrEquals(\.self, rhs)
  }
  
}

extension Comparable {
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validator<Value> {
    Validation<Value>.greaterThan(lhs, rhs)
  }
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    greaterThan(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validator<Value> {
    greaterThan(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func greaterThan<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    greaterThan({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThan(_ other: Self) -> some Validator<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public static func greaterThan(_ other: KeyPath<Self, Self>) -> some Validator<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public func greaterThanValidator() -> some Validator<Self> {
    Self.greaterThan(self)
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validator<Value> {
    Validation<Value>.greaterThanOrEquals(lhs, rhs)
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    greaterThanOrEquals(lhs.value(from:), rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validator<Value> {
    greaterThanOrEquals(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func greaterThanOrEquals<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    greaterThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func greaterThanOrEquals(_ other: Self) -> some Validator<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public static func greaterThanOrEquals(_ other: KeyPath<Self, Self>) -> some Validator<Self> {
    greaterThan(\.self, other)
  }
  
  @inlinable
  public func greaterThanOrEqualsValidator() -> some Validator<Self> {
    Self.greaterThan(self)
  }
}

// MARK: - Less Than

extension Validation {
  
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

extension Validation where Value: Comparable {
  
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
  ) -> some Validator<Value> {
    Validation<Value>.lessThan(lhs, rhs)
  }
  
  @inlinable
  public static func lessThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    lessThan(lhs.value(from:), rhs.value(from:))
  }
  @inlinable
  public static func lessThan<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validator<Value> {
    lessThan(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func lessThan<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    lessThan({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func lessThan(_ other: Self) -> some Validator<Self> {
    lessThan(\.self, other)
  }
  
  @inlinable
  public static func lessThan(_ other: KeyPath<Self, Self>) -> some Validator<Self> {
    lessThan(\.self, other)
  }
  
  @inlinable
  public func lessThanValidator() -> some Validator<Self> {
    Self.lessThan(self)
  }
  
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: @escaping (Value) -> Self,
    _ rhs: @escaping (Value) -> Self
  ) -> some Validator<Value> {
    Validation<Value>.lessThanOrEquals(lhs, rhs)
  }
  
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    lessThanOrEquals(lhs.value(from:), rhs.value(from:))
  }
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: KeyPath<Value, Self>,
    _ rhs: Self
  ) -> some Validator<Value> {
    lessThanOrEquals(lhs.value(from:), { _ in rhs })
  }
  
  @inlinable
  public static func lessThanOrEquals<Value>(
    _ lhs: Self,
    _ rhs: KeyPath<Value, Self>
  ) -> some Validator<Value> {
    lessThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
  
  @inlinable
  public static func lessThanOrEquals(_ other: Self) -> some Validator<Self> {
    lessThanOrEquals(\.self, other)
  }
  
  @inlinable
  public static func lessThanOrEquals(_ other: KeyPath<Self, Self>) -> some Validator<Self> {
    lessThanOrEquals(\.self, other)
  }
  
  @inlinable
  public func lessThanOrEqualsValidator() -> some Validator<Self> {
    Self.lessThanOrEquals(self)
  }
}

