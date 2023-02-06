extension Validation {

  /// Replaces the error of a ``Validation`` when it fails.
  ///
  /// **Example**
  /// ```swift
  ///  enum MyError: Error {
  ///   case invalidString
  ///  }
  ///
  ///  let validator = String.notEmpty().mapError { error in
  ///   // do something
  ///   throw MyError.invalidString
  ///  }
  ///
  ///  try validator.validate("") // throws MyError.invalidString
  /// ```
  ///
  /// - Parameters:
  ///   - error: The error that replaces the underlying error.
  ///
  @inlinable
  public func mapError(_ error: @escaping (Error) throws -> Void) -> Validators.MapError<Self> {
    Validators.MapError(upstream: self, with: error)
  }

  /// Replaces the error of a ``Validation`` when it fails.
  ///
  /// **Example**
  /// ```swift
  ///  enum MyError: Error {
  ///   case invalidString
  ///  }
  ///
  ///  let validator = String.notEmpty().mapError(MyError.invalidString)
  ///
  ///  try validator.validate("") // throws MyError.invalidString
  /// ```
  ///
  /// - Parameters:
  ///   - error: The error that replaces the underlying error.
  ///
  @inlinable
  public func mapError(_ error: Error) -> Validators.MapError<Self> {
    mapError({ _ in throw error })
  }
}

extension AsyncValidation {

  /// Replaces the error of an ``AsyncValidation`` when it fails.
  ///
  /// **Example**
  /// ```swift
  ///  enum MyError: Error {
  ///   case invalidString
  ///  }
  ///
  ///  let validator = String.notEmpty().async.mapError(MyError.invalidString)
  ///
  ///  try await validator.validate("") // throws MyError.invalidString
  /// ```
  ///
  /// - Parameters:
  ///   - error: The error that replaces the underlying error.
  ///
  @inlinable
  public func mapError(_ error: Error) -> Validators.MapError<Self> {
    Validators.MapError(upstream: self, with: { _ in throw error })
  }

  /// Replaces the error of a ``AsyncValidation`` when it fails.
  ///
  /// **Example**
  /// ```swift
  ///  enum MyError: Error {
  ///   case invalidString
  ///  }
  ///
  ///  let validator = String.notEmpty().async.mapError { error in
  ///   // do something
  ///   throw MyError.invalidString
  ///  }
  ///
  ///  try await validator.validate("") // throws MyError.invalidString
  /// ```
  ///
  /// - Parameters:
  ///   - error: The error that replaces the underlying error.
  ///
  @inlinable
  public func mapError(_ error: @escaping (Error) throws -> Void) -> Validators.MapError<Self> {
    Validators.MapError(upstream: self, with: error)
  }
}

extension Validators {

  /// A ``Validation`` that replaces the error with the given error if validation fails.
  ///
  /// This is generally not interacted with directly, instead you call the ``Validation/mapError(_:)-6sc4w``
  /// method on an existing validator or the equivalent on an async validation``AsyncValidation/mapError(_:)-9k35j``.
  ///
  public struct MapError<Upstream> {

    public let upstream: Upstream
    public let error: (Error) throws -> Void

    /// Create a ``Validators/MapError`` that replaces the underlying error if validation fails.
    ///
    /// - Parameters:
    ///   - upstream: The upstream validator.
    ///   - error: The error to throw if validation fails.
    @inlinable
    public init(upstream: Upstream, with error: @escaping (Error) throws -> Void) {
      self.upstream = upstream
      self.error = error
    }

  }
}

extension Validators.MapError: Validation where Upstream: Validation {
  @inlinable
  public func validate(_ value: Upstream.Value) throws {
    do {
      try upstream.validate(value)
    } catch {
      // map the error.
      try self.error(error)
    }
  }
}

extension Validators.MapError: AsyncValidation where Upstream: AsyncValidation {
  @inlinable
  public func validate(_ value: Upstream.Value) async throws {
    do {
      try await upstream.validate(value)
    } catch {
      // map the error.
      try self.error(error)
    }
  }
}
