import CasePaths

/// Used for validating an enum case.
public struct Case<Parent, Child> {
  @usableFromInline
  let casePath: CasePath<Parent, Child>

  @usableFromInline
  let file: StaticString

  @usableFromInline
  let fileID: StaticString

  @usableFromInline
  let line: UInt

  @usableFromInline
  let validator: any Validator<Child>

  @inlinable
  public init(
    _ casePath: CasePath<Parent, Child>,
    using validator: any Validator<Child>,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line
  ) {
    self.casePath = casePath
    self.validator = validator
    self.file = file
    self.fileID = fileID
    self.line = line
  }

  @inlinable
  public init<V: Validator>(
    _ casePath: CasePath<Parent, Child>,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    @ValidationBuilder<Child> validator: @escaping () -> V
  ) where V.Value == Child {
    self.init(casePath, using: validator(), file: file, fileID: fileID, line: line)
  }
}

extension Case: Validator {
  public typealias Value = Parent

  @inlinable
  public func validate(_ value: Parent) throws {
    guard let child = casePath.extract(from: value) else {
      let message = """
        A "Case" validation at "\(self.fileID):\(self.line)" does not handle the current case.

        Current case is: \(value)
        """
      throw ValidationError(message: message)
    }
    try validator.validate(child)
  }
}
