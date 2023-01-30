
public struct Validate<Parent, Child>: Validator {
  
  @usableFromInline
  let child: (Parent) -> Child
  
  @usableFromInline
  let validator: (Parent) -> any Validator<Child>
  
  @usableFromInline
  init(
    _ child: @escaping (Parent) -> Child,
    validator: @escaping (Parent) -> any Validator<Child>
  ) {
    self.child = child
    self.validator = validator
  }
  
  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>,
    @ValidationBuilder<Child> build: () -> some Validator<Child>
  ) {
    self.init(toChild, using: build())
  }
  
  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>,
    using validator: some Validator<Child>
  ) {
    self.init(
      toChild.value(from:),
      validator: { _ in validator }
    )
  }
  
  @inlinable
  public init(
    _ toChild: KeyPath<Parent, Child>
  ) where Child: Validatable {
    self.init(toChild.value(from:), validator: toChild.value(from:))
  }

  @inlinable
  public func validate(_ parent: Parent) throws {
    let value = child(parent)
    try validator(parent).validate(value)
  }
}
