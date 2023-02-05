import Foundation

// TODO: Better labeled error messages?

@usableFromInline
enum ValidationError: Error {
  case failed(ErrorLabel, Context)
  case manyFailed([Error], Context)

  @usableFromInline
  static func failed(summary: String, label: String = "", inlineLabel: Bool = false) -> Self {
    return .failed(.init(label: label, isInline: inlineLabel), .init(debugDescription: summary))
  }

  @usableFromInline
  static func failed(label: String, error: Error, inlineLabel: Bool = false) -> Self {
    .failed(
      .init(label: label, isInline: inlineLabel),
      .init(
        debugDescription: formatError(error),
        underlyingError: error
      )
    )
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

  @usableFromInline
  enum ErrorLabel {
    case inline(String)
    case notInline(String)

    @usableFromInline
    init(label: String, isInline: Bool) {
      if isInline {
        self = .inline(label)
      } else {
        self = .notInline(label)
      }
    }

    @usableFromInline
    var isEmpty: Bool { label.isEmpty }

    @usableFromInline
    var isInline: Bool {
      switch self {
      case .inline:
        return true
      case .notInline:
        return false
      }
    }

    @usableFromInline
    var label: String {
      switch self {
      case let .inline(label):
        return label
      case let .notInline(label):
        return label
      }
    }
  }
}

extension ValidationError: CustomDebugStringConvertible {

  @usableFromInline
  func flattened() -> Self {
    func flatten(_ depth: Int = 0) -> (Error) -> [(depth: Int, error: Error)] {
      { error in
        switch error {
        case let ValidationError.manyFailed(errors, _):
          return errors.flatMap(flatten(depth + 1))
        default:
          return [(depth, error)]
        }
      }
    }

    switch self {
    case .failed:
      return self
    case let .manyFailed(errors, context):
      // sorts unlabeled errors to the top.
      return .manyFailed(
        errors.flatMap(flatten())
          .sorted { $0.depth < $1.depth }
          .map { $0.error },
        context
      )
    }
  }

  @usableFromInline
  var debugDescription: String {
    switch self.flattened() {
    case let .failed(label, context):
      return format(label: label, context: context)
    case let .manyFailed(errors, _):
      return debugDescription(for: errors)
    }
  }

  @usableFromInline
  func format(label: ErrorLabel, context: Context) -> String {
    guard !label.isEmpty else {
      return "\(context.debugDescription)"
    }
    let seperator = label.isInline ? ": " : ":\n"
    return "\(label.label)\(seperator)\(context.debugDescription)"
  }

  @usableFromInline
  func debugDescription(for errors: [Error]) -> String {

    func isFailed(_ error: Error) -> (ErrorLabel, Context)? {
      guard let error = error as? ValidationError,
        case let .failed(label, context) = error
      else {
        return nil
      }
      return (label, context)

    }

    var description = ""
    var count = 0

    func append(_ string: String) {
      count += 1
      if !description.isEmpty {
        description.append("\n")
      }
      description.append(string)
    }

    var errors = errors[...]
    while let error = errors.popFirst() {
      guard case let .some((label, context)) = isFailed(error) else {
        append("\(formatError(error))")
        continue
      }
      append(format(label: label, context: context))
    }

    return "\(description)\n"
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
