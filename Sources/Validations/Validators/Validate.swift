
public struct Validate<Parent, Child>: Validator {
  
  @usableFromInline
  let child: (Parent) -> Child
  
  @usableFromInline
  let validator: (Parent) -> any Validator<Child>
  
  @usableFromInline
  init(
    _ child: @escaping (Parent) -> Child,
    _ validator: @escaping (Parent) -> any Validator<Child>
  ) {
    self.child = child
    self.validator = validator
  }
  
  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>,
    @ValidationBuilder<Child> _ validator: () -> some Validator<Child>
  ) {
    self.init(toChild, validator())
  }
  
  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>,
    _ validator: some Validator<Child>
  ) {
    self.init(
      toChild.value(from:),
      { _ in validator }
    )
  }
  
  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>
  ) where Child: Validatable {
    self.init(toChild.value(from:), toChild.value(from:))
  }

  @inlinable
  public func validate(_ parent: Parent) throws {
    let value = child(parent)
    try validator(parent).validate(value)
  }
}
