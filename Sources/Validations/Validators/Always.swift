
/// A validator that always succeeds.
///
/// Example:
/// ```
/// let always = Always<String>()
///
/// try! always.validate("")
/// // succeeds
/// ```
public struct Always<Value>: Validator {
  
  @inlinable
  public init() { }
 
  @inlinable
  public func validate(_ value: Value) throws {
    // do nothing.
  }
}
