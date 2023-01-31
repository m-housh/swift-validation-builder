import Foundation

@usableFromInline
enum ValidationError: Error {
  case failed(Context)
  case manyFailed([Error], Context)

  @usableFromInline
  static func failed(summary: String) -> Self {
    .failed(.init(debugDescription: summary))
  }

  @usableFromInline
  static func manyFailed(_ errors: [Error]) -> Self {
    .manyFailed(errors, .init(debugDescription: ""))
  }

  @usableFromInline
  struct Context {
    let debugDescription: String
    let underlyingError: Error?

    @usableFromInline
    init(
      debugDescription: String,
      underlyingError: Error? = nil
    ) {
      self.debugDescription = debugDescription
      self.underlyingError = underlyingError
    }
  }
}

extension ValidationError: CustomDebugStringConvertible {

  @usableFromInline
  var debugDescription: String {
    switch self {
    case let .failed(context):
      return context.debugDescription
    case let .manyFailed(errors, _):
      return
        errors
        .map(formatError(_:))
        .joined(separator: "\n")
    }
  }
}

private func formatError(_ error: Error) -> String {
  switch error {
  case let error as ValidationError:
    return error.debugDescription

  case let error as LocalizedError:
    return error.localizedDescription

  default:
    return "\(error)"
  }
}
