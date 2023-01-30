//public struct ValidationError: Error, Equatable {
//  public let message: String
//
//  @inlinable
//  public init(message: String) {
//    self.message = message
//  }
//}

@usableFromInline
enum ValidationError: Error {
  case failed(message: String)
  case manyFailed(messages: [String])

  @inlinable
  init(message: String) {
    self = .failed(message: message)
  }

  @inlinable
  init(messages: [String]) {
    self = .manyFailed(messages: messages)
  }
}

extension ValidationError: CustomDebugStringConvertible {

  @usableFromInline
  var debugDescription: String {
    switch self {
    case let .failed(message: message):
      return "Validation Error: \(message)"
    case let .manyFailed(messages: messages):
      let messageString = messages.joined(separator: "\n")
      return """
        Validation Error:
        \(messageString)
        """
    }
  }
}
