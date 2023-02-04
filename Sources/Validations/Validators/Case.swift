import CasePaths
import XCTestDynamicOverlay

extension Validators {
  /// A ``Validation`` used for validating values that are embedded inside of an enum case.
  ///
  /// We can not ensure that all cases get handled when building validations for enum values, but if the `validate`
  /// method is called with an un-handled case an `XCTFail` and runtime warning will be thrown,
  /// when not inside a testing context.
  ///
  /// This is not interected with directly, instead use one of the ``Validators/Case(_:with:file:fileID:line:)-6rsds`` methods
  /// to create a ``Validators/CaseValidator``.
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
  public struct CaseValidator<Parent, Child, ChildValidator> {

    /// The case path to use to access the child value.
    public let casePath: CasePath<Parent, Child>

    /// The validator to use when we found a child value in the case path.
    public let validator: ChildValidator

    @usableFromInline
    let file: StaticString

    @usableFromInline
    let fileID: StaticString

    @usableFromInline
    let line: UInt

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
      using validator: ChildValidator,
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

    }
}

extension Validators {
  
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
  public static func Case<Parent, Child>(
    _ casePath: CasePath<Parent, Child>,
    with validator: Validator<Child>,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line
  ) -> CaseValidator<Parent, Child, Validator<Child>> {
    .init(
      casePath,
      using: validator,
      file: file,
      fileID: fileID,
      line: line
    )
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
  public static func Case<Parent, ChildValidator: Validation>(
    _ casePath: CasePath<Parent, ChildValidator.Value>,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    @ValidationBuilder<ChildValidator.Value> validator: @escaping () -> ChildValidator
  ) -> CaseValidator<Parent, ChildValidator.Value, ChildValidator> {
    .init(
      casePath,
      using: validator(),
      file: file,
      fileID: fileID,
      line: line
    )
  }
  
  /// Create an enum case validation, using the given ``AsyncValidator`` for the value embedded in the case.
  ///
  /// This is convenience for using static methods, such as ``Validator/greaterThan(_:)``.
  ///
  /// - Parameters:
  ///   - casePath: The case path for the enum.
  ///   - validator: The ``AsyncValidator`` to use for the embedded value.
  ///   - file: The file.
  ///   - fileID: The file id.
  ///   - line: The line.
  ///
  @inlinable
  public static func Case<Parent, Child>(
    _ casePath: CasePath<Parent, Child>,
    with validator: AsyncValidator<Child>,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line
  ) -> CaseValidator<Parent, Child, AsyncValidator<Child>> {
    .init(
      casePath,
      using: validator,
      file: file,
      fileID: fileID,
      line: line
    )
  }
  
  
  /// Create an enum case validation, using  the result builder syntax for the value embedded in the case.
  ///
  ///
  /// - Parameters:
  ///   - casePath: The case path for the enum.
  ///   - file: The file.
  ///   - fileID: The file id.
  ///   - line: The line.
  ///   - validator: The ``AsyncValidation`` to use for the embedded value.
  @inlinable
  public static func Case<Parent, ChildValidator: AsyncValidation>(
    _ casePath: CasePath<Parent, ChildValidator.Value>,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    @ValidationBuilder<ChildValidator.Value> validator: @escaping () -> ChildValidator
  ) -> CaseValidator<Parent, ChildValidator.Value, ChildValidator> {
    .init(
      casePath,
      using: validator(),
      file: file,
      fileID: fileID,
      line: line
    )
  }
}


extension Validators.CaseValidator: Validation
where
  ChildValidator: Validation,
  ChildValidator.Value == Child
{

  @inlinable
  public func validate(_ value: Parent) throws {
    guard let child = casePath.extract(from: value) else {
      let message = self.errorMessage(value)
      if !_XCTIsTesting {
        // Throw a runtime warning, if a case was not handled.
        XCTFail(message, file: file, line: line)
      }
      throw ValidationError.failed(summary: message)
    }
    try validator.validate(child)
  }
}

extension Validators.CaseValidator: AsyncValidation
where
  ChildValidator: AsyncValidation,
  ChildValidator.Value == Child
{

  @inlinable
  public func validate(_ value: Parent) async throws {
    guard let child = casePath.extract(from: value) else {
      let message = self.errorMessage(value)
      if !_XCTIsTesting {
        // Throw a runtime warning, if a case was not handled.
        XCTFail(message, file: file, line: line)
      }
      throw ValidationError.failed(summary: message)
    }
    try await validator.validate(child)
  }
}

extension Validators.CaseValidator {
  
  @usableFromInline
  func errorMessage(_ parent: Parent) -> String {
    """
      A "Case" validation at "\(self.fileID):\(self.line)" does not handle the current case.
        
      Current case is: \(parent)
    """
  }
}
