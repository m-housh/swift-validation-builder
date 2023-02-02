import Foundation

// TODO: Support labels to errors when there are `many` errors.
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
      let beginning = "Validation Error:\n\t• "
      let flattenedErrors = flatten(errors: errors)
      let errorString =
        flattenedErrors
        .map(formatError(_:))
        .joined(separator: "\n\t• ")

      return beginning + errorString
    }
  }
}

private func flatten(errors: [Error]) -> [Error] {
  var flattened = [Error]()
  for error in errors {
    if let validationError = error as? ValidationError,
      case let .manyFailed(manyErrors, _) = validationError
    {
      flattened += flatten(errors: manyErrors)
    } else {
      flattened.append(error)
    }
  }
  return flattened
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
