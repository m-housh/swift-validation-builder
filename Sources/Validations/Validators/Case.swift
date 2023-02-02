import CasePaths
import XCTestDynamicOverlay

extension Validators {
  /// A ``Validation`` used for validating values that are embedded inside of an enum case.
  ///
  /// We can not ensure that all cases get handled when validating enum values, but if the ``Validators/Case/validate(_:)``
  /// method is called with an un-handled case an `XCTFail` and runtime warning will be thrown, when not inside a testing context.
  ///
  /// **Example**
  /// ```swift
  /// enum MyEnum {
  ///   case one(Int)
  ///   case two(Int)
  ///   case three(Int)
  /// }
  ///
  /// let myValidator = OneOf {
  ///   Validators.Case(/MyEnum.one, using: .greaterThan(0))
  ///   Validators.Case(/MyEnum.two, using: .greaterThan(10))
  /// }
  ///
  /// try myValidator.validate(.one(1)) // succeeds.
  /// try myValidator.validate(.two(11)) // succeeds.
  /// try myValidator.validate(.three(3)) // runtime warning + error
  ///
  /// ```
  ///
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
    let validator: any Validation<Child>
    
    /// Create an enum case validation, using the given ``Validation`` for the value embedded in the case.
    ///
    /// - Parameters:
    ///   - casePath: The case path for the enum.
    ///   - validator: The ``Validation`` to use for the embedded value.
    ///   - file: The file.
    ///   - fileID: The file id.
    ///   - line: The line.
    ///
    @inlinable
    public init(
      _ casePath: CasePath<Parent, Child>,
      using validator: any Validation<Child>,
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
    
    /// Create an enum case validation, using the given ``Validator`` for the value embedded in the case.
    ///
    /// This is convenience for using static methods, such as ``Validator/greaterThan(_:)``.
    ///
    /// - Parameters:
    ///   - casePath: The case path for the enum.
    ///   - validator: The ``Validator`` to use for the embedded value.
    ///   - file: The file.
    ///   - fileID: The file id.
    ///   - line: The line.
    ///
    @inlinable
    public init(
      _ casePath: CasePath<Parent, Child>,
      using validator: Validator<Child>,
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
    
    
    /// Create an enum case validation, using  the result builder syntax for the value embedded in the case.
    ///
    ///
    /// - Parameters:
    ///   - casePath: The case path for the enum.
    ///   - file: The file.
    ///   - fileID: The file id.
    ///   - line: The line.
    ///   - validator: The ``Validation`` to use for the embedded value.
    @inlinable
    public init<V: Validation>(
      _ casePath: CasePath<Parent, Child>,
      file: StaticString = #file,
      fileID: StaticString = #fileID,
      line: UInt = #line,
      @ValidationBuilder<Child> validator: @escaping () -> V
    ) where V.Value == Child {
      self.init(casePath, using: validator(), file: file, fileID: fileID, line: line)
    }
  }
}

extension Validators.Case: Validation {
  public typealias Value = Parent
  
  @inlinable
  public func validate(_ value: Parent) throws {
    guard let child = casePath.extract(from: value) else {
      let message = """
        A "Case" validation at "\(self.fileID):\(self.line)" does not handle the current case.
        
        Current case is: \(value)
        """
      if !_XCTIsTesting {
        // fail tests and throw a runtime warning, if a case was not
        // handled.
        XCTFail(message, file: file, line: line)
      }
      throw ValidationError.failed(summary: message)
    }
    try validator.validate(child)
  }
}
