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
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  ///
  @inlinable
  public static func equals<Element: Equatable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
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

extension Validator where Value: Equatable {

  /// Create a ``Validator`` that fails if the value does not equal the given value.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let intValidator = ValidatorOf<Int>.equals(10)
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value that we should equal  when validating values.
  @inlinable
  public static func equals(
    _ value: Value
  ) -> Self {
    .equals({ $0 }, { _ in value })
  }
}


// MARK: - Greater Than
extension Validator {

  /// Create a ``Validator`` that validates the left hand side is greater than the right hand side,
  /// using closures to access the elements.
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
  /// let validator = ValidatorOf<Example>.greaterThan({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 > $1 },
        operatorString: "greater than")
    )
  }

  /// Create a ``Validator`` that validates the left hand side is greater than the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = ValidatorOf<Example>.greaterThan(\.count, \.deeply.nested.value)
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThan(lhs.value(from:), rhs.value(from:))
  }

  /// Create a ``Validator`` that validates the left hand side is greater than the right hand side,
  /// using `KeyPath` to access the left hand side element, and a concrete instance for the right hand side.
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
  /// let validator = ValidatorOf<Example>.greaterThan(\.count, 10)
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    greaterThan(lhs.value(from:), { _ in rhs })
  }

  /// Create a ``Validator`` that validates the left hand side is greater than the right hand side,
  /// using `KeyPath` to access the right hand side element, and a concrete instance for the left hand side.
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
  /// let validator = ValidatorOf<Example>.greaterThan(10, \.count)
  ///
  /// try validator.validate(.init(count: 9)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: The left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThan({ _ in lhs }, rhs.value(from:))
  }

  /// Create a ``Validator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using closures to access the elements.
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
  /// let validator = ValidatorOf<Example>.greaterThanOrEquals({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 >= $1 },
        operatorString: "greater than or equal to")
    )
  }

  /// Create a ``Validator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = ValidatorOf<Example>.greaterThanOrEquals(\.count, \.deeply.nested.value)
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThanOrEquals(lhs.value(from:), rhs.value(from:))
  }

  /// Create a ``Validator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using `KeyPath` to access the left hand side element and a concrete value for the right side.
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
  /// let validator = ValidatorOf<Example>.greaterThanOrEquals(\.count, 10)
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    greaterThanOrEquals(lhs.value(from:), { _ in rhs })
  }

  /// Create a ``Validator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using `KeyPath` to access the right hand side element and a concrete value for the left hand side.
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
  /// let validator = ValidatorOf<Example>.greaterThanOrEquals(10, \.count)
  ///
  /// try validator.validate(.init(count: 9)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: The left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
}

extension Validator where Value: Comparable {

  /// Create a ``Validator`` that validates the value is greater than the given value
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int>.greaterThan(10)
  ///
  /// try intValidator.validate(11) // succeeds.
  /// try intValidator.validate(9) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value we should use to compare values are greater than.
  ///
  @inlinable
  public static func greaterThan(_ value: Value) -> Self {
    greaterThan(\.self, value)
  }

  /// Create a ``Validator`` that validates the value is greater than or equal to the given value
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = ValidatorOf<Int>.greaterThanOrEquals(10)
  ///
  /// try intValidator.validate(10) // succeeds.
  /// try intValidator.validate(9) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value we should use to compare values are greater than or equal to.
  ///
  @inlinable
  public static func greaterThanOrEquals(_ rhs: Value) -> Self {
    greaterThanOrEquals(\.self, rhs)
  }

}



// MARK: - Less Than

extension Validator {
  /// Create a ``Validator`` that validates the left hand side is less than the right hand side,
  /// using closures to access the elements.
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
  /// let validator = ValidatorOf<Example>.lessThan({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try validator.validate(.init(count: 9)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 < $1 },
        operatorString: "less than")
    )
  }

  /// Create a ``Validator`` that validates the left hand side is less than the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = ValidatorOf<Example>.lessThan(\.count, \.deeply.nested.value)
  ///
  /// try validator.validate(.init(count: 9)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThan(lhs.value(from:), rhs.value(from:))
  }

  /// Create a ``Validator`` that validates the left hand side is less than the right hand side,
  /// using `KeyPath` to access the left hand side element and a concrete value as the right hand side.
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
  /// let validator = ValidatorOf<Example>.lessThan(\.count, 10)
  ///
  /// try validator.validate(.init(count: 9)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    lessThan(lhs.value(from:), { _ in rhs })
  }

  /// Create a ``Validator`` that validates the left hand side is less than the right hand side,
  /// using `KeyPath` to access the right hand side element and a concrete value as the left hand side.
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
  /// let validator = ValidatorOf<Example>.lessThan(10, \.count)
  ///
  /// try validator.validate(.init(count: 11)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThan({ _ in lhs }, rhs.value(from:))
  }

  /// Create a ``Validator`` that validates the left hand side is less than or equal to the right hand side,
  /// using closures to access the elements.
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
  /// let validator = ValidatorOf<Example>
  ///   .lessThanOrEquals({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try validator.validate(.init(count: 10)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 <= $1 },
        operatorString: "less than or equal to")
    )
  }

  /// Create a ``Validator`` that validates the left hand side is less than or equal to the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = ValidatorOf<Example>
  ///   .lessThanOrEquals(\.count, \.deeply.nested.value)
  ///
  /// try validator.validate(.init(count: 10)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThanOrEquals(lhs.value(from:), rhs.value(from:))
  }

  /// Create a ``Validator`` that validates the left hand side is less than or equal to the right hand side,
  /// using `KeyPath` to access the left hand side element and a concrete value for the right hand side.
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
  /// let validator = ValidatorOf<Example>
  ///   .lessThanOrEquals(\.count, 10)
  ///
  /// try validator.validate(.init(count: 10)) // succeeds.
  /// try validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    lessThanOrEquals(lhs.value(from:), { _ in rhs })
  }

  /// Create a ``Validator`` that validates the left hand side is less than or equal to the right hand side,
  /// using `KeyPath` to access the right hand side element and a concrete value for the left hand side.
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
  /// let validator = ValidatorOf<Example>
  ///   .lessThanOrEquals(10, \.count)
  ///
  /// try validator.validate(.init(count: 10)) // succeeds.
  /// try validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
}

extension Validator where Value: Comparable {

  /// Create a ``Validator`` that validates the value is less than the given value,
  ///
  /// **Example**
  ///```swift
  /// let validator = ValidatorOf<Int>.lessThan(11)
  ///
  /// try validator.validate(10) // succeeds.
  /// try validator.validate(12) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - value: The value that values should be less than during validaiton.
  ///
  @inlinable
  public static func lessThan(_ value: Value) -> Self {
    lessThan(\.self, value)
  }

  /// Create a ``Validator`` that validates the value is less than or equal to the given value,
  ///
  /// **Example**
  ///```swift
  /// let validator = ValidatorOf<Int>.lessThanOrEquals(11)
  ///
  /// try validator.validate(11) // succeeds.
  /// try validator.validate(12) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - value: The value that values should be less than or equal to during validaiton.
  ///
  @inlinable
  public static func lessThanOrEquals(_ value: Value) -> Self {
    lessThanOrEquals(\.self, value)
  }

}



// MARK: - Async Support

extension AsyncValidator {

  // MARK: - Equatable

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
  /// let validator = AsyncValidatorOf<Example>.equals({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try await validator.validate(.init(count: 10)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  public static func equals<Element: Equatable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
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

extension AsyncValidator where Value: Equatable {

  /// Create an ``AsyncValidator`` that fails if the value does not equal the given value.
  ///
  /// **Example**
  ///
  /// ```swift
  /// let intValidator = AsyncValidatorOf<Int>.equals(10)
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value that we should equal  when validating values.
  @inlinable
  public static func equals(
    _ value: Value
  ) -> Self {
    .equals({ $0 }, { _ in value })
  }
}

// MARK: - Greater Than
extension AsyncValidator {

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than the right hand side,
  /// using closures to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>.greaterThan({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 > $1 },
        operatorString: "greater than")
    )
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>.greaterThan(\.count, \.deeply.nested.value)
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThan(lhs.value(from:), rhs.value(from:))
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than the right hand side,
  /// using `KeyPath` to access the left hand side element, and a concrete instance for the right hand side.
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
  /// let validator = AsyncValidatorOf<Example>.greaterThan(\.count, 10)
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    greaterThan(lhs.value(from:), { _ in rhs })
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than the right hand side,
  /// using `KeyPath` to access the right hand side element, and a concrete instance for the left hand side.
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
  /// let validator = AsyncValidatorOf<Example>.greaterThan(10, \.count)
  ///
  /// try await validator.validate(.init(count: 9)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: The left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThan<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThan({ _ in lhs }, rhs.value(from:))
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using closures to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>
  ///   .greaterThanOrEquals({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 >= $1 },
        operatorString: "greater than or equal to")
    )
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>
  ///   .greaterThanOrEquals(\.count, \.deeply.nested.value)
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThanOrEquals(lhs.value(from:), rhs.value(from:))
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using `KeyPath` to access the left hand side element and a concrete value for the right side.
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
  /// let validator = AsyncValidatorOf<Example>.greaterThanOrEquals(\.count, 10)
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    greaterThanOrEquals(lhs.value(from:), { _ in rhs })
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is greater than or equal to the right hand side,
  /// using `KeyPath` to access the right hand side element and a concrete value for the left hand side.
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
  /// let validator = AsyncValidatorOf<Example>.greaterThanOrEquals(10, \.count)
  ///
  /// try await validator.validate(.init(count: 9)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: The left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func greaterThanOrEquals<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    greaterThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
}

extension AsyncValidator where Value: Comparable {

  /// Create an ``AsyncValidator`` that validates the value is greater than the given value
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = AsyncValidatorOf<Int>.greaterThan(10)
  ///
  /// try await intValidator.validate(11) // succeeds.
  /// try await intValidator.validate(9) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value we should use to compare values are greater than.
  ///
  @inlinable
  public static func greaterThan(_ value: Value) -> Self {
    greaterThan(\.self, value)
  }

  /// Create an ``AsyncValidator`` that validates the value is greater than or equal to the given value
  ///
  /// **Example**
  /// ```swift
  /// let intValidator = AsyncValidatorOf<Int>.greaterThanOrEquals(10)
  ///
  /// try await intValidator.validate(10) // succeeds.
  /// try await intValidator.validate(9) // fails.
  /// ```
  ///
  /// - Parameters:
  ///   - value: The value we should use to compare values are greater than or equal to.
  ///
  @inlinable
  public static func greaterThanOrEquals(_ rhs: Value) -> Self {
    greaterThanOrEquals(\.self, rhs)
  }

}

// MARK: - Less Than

extension AsyncValidator {
  /// Create an ``AsyncValidator`` that validates the left hand side is less than the right hand side,
  /// using closures to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>.lessThan({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try await validator.validate(.init(count: 9)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 < $1 },
        operatorString: "less than")
    )
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>.lessThan(\.count, \.deeply.nested.value)
  ///
  /// try await validator.validate(.init(count: 9)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThan(lhs.value(from:), rhs.value(from:))
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than the right hand side,
  /// using `KeyPath` to access the left hand side element and a concrete value as the right hand side.
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
  /// let validator = AsyncValidatorOf<Example>.lessThan(\.count, 10)
  ///
  /// try await validator.validate(.init(count: 9)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    lessThan(lhs.value(from:), { _ in rhs })
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than the right hand side,
  /// using `KeyPath` to access the right hand side element and a concrete value as the left hand side.
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
  /// let validator = AsyncValidatorOf<Example>.lessThan(10, \.count)
  ///
  /// try await validator.validate(.init(count: 11)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThan<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThan({ _ in lhs }, rhs.value(from:))
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than or equal to the right hand side,
  /// using closures to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>
  ///   .lessThanOrEquals({ $0.count }, { $0.deeply.nested.value })
  ///
  /// try await validator.validate(.init(count: 10)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: @escaping (Value) -> Element,
    _ rhs: @escaping (Value) -> Element
  ) -> Self {
    .init(
      Validators.ComparableValidator(
        lhs,
        rhs,
        operator: { $0 <= $1 },
        operatorString: "less than or equal to")
    )
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than or equal to the right hand side,
  /// using `KeyPath`'s to access the elements.
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
  /// let validator = AsyncValidatorOf<Example>
  ///   .lessThanOrEquals(\.count, \.deeply.nested.value)
  ///
  /// try await validator.validate(.init(count: 10)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: Retrieve the right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThanOrEquals(lhs.value(from:), rhs.value(from:))
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than or equal to the right hand side,
  /// using `KeyPath` to access the left hand side element and a concrete value for the right hand side.
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
  /// let validator = AsyncValidatorOf<Example>
  ///   .lessThanOrEquals(\.count, 10)
  ///
  /// try await validator.validate(.init(count: 10)) // succeeds.
  /// try await validator.validate(.init(count: 11)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: KeyPath<Value, Element>,
    _ rhs: Element
  ) -> Self {
    lessThanOrEquals(lhs.value(from:), { _ in rhs })
  }

  /// Create an ``AsyncValidator`` that validates the left hand side is less than or equal to the right hand side,
  /// using `KeyPath` to access the right hand side element and a concrete value for the left hand side.
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
  /// let validator = AsyncValidatorOf<Example>
  ///   .lessThanOrEquals(10, \.count)
  ///
  /// try await validator.validate(.init(count: 10)) // succeeds.
  /// try await validator.validate(.init(count: 9)) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - lhs: Retrieve the left hand side element.
  ///   - rhs: The right hand side element.
  ///
  @inlinable
  public static func lessThanOrEquals<Element: Comparable>(
    _ lhs: Element,
    _ rhs: KeyPath<Value, Element>
  ) -> Self {
    lessThanOrEquals({ _ in lhs }, rhs.value(from:))
  }
}

extension AsyncValidator where Value: Comparable {

  /// Create an ``AsyncValidator`` that validates the value is less than the given value,
  ///
  /// **Example**
  ///```swift
  /// let validator = AsyncValidatorOf<Int>.lessThan(11)
  ///
  /// try await validator.validate(10) // succeeds.
  /// try await validator.validate(12) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - value: The value that values should be less than during validaiton.
  ///
  @inlinable
  public static func lessThan(_ value: Value) -> Self {
    lessThan(\.self, value)
  }

  /// Create an ``AsyncValidator`` that validates the value is less than or equal to the given value,
  ///
  /// **Example**
  ///```swift
  /// let validator = AsyncValidatorOf<Int>.lessThanOrEquals(11)
  ///
  /// try await validator.validate(11) // succeeds.
  /// try await validator.validate(12) // fails.
  ///
  ///```
  ///
  /// - Parameters:
  ///   - value: The value that values should be less than or equal to during validaiton.
  ///
  @inlinable
  public static func lessThanOrEquals(_ value: Value) -> Self {
    lessThanOrEquals(\.self, value)
  }

}

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

    /// Create a comparison validation with custom access to the elements and custom logic to evaluate the comparison.
    ///
    /// - Parameters:
    ///   - lhs: Return the left hand side of the comparison from the parent context.
    ///   - rhs: Return the right hand side of the comparison from the parent context.
    ///   - operator: The expression used to evaluate the elements.
    ///   - operatorString: Used in error messages generated when validation fails.
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
