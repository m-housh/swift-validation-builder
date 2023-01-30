
public struct NotEmpty<Value: Collection>: Validator {
  
  public init() { }
  
  public var body: some Validator<Value> {
    Not(Empty())
  }
}
