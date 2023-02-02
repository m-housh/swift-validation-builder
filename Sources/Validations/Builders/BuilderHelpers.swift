// This file holds types that are used internally, although they are `public`, they
// should generally not be interacted with, except when in a result builder context.

public enum _Sequence<V0, V1> {
  case accumulating(V0, V1)
  case failEarly(V0, V1)
  case oneOf(V0, V1)
}

public enum _SequenceMany<V> {
  case accumulating([V])
  case failEarly([V])
  case oneOf([V])
}

public enum _Conditional<True, False> {
  case first(True)
  case second(False)
}

extension _Conditional: Validation
where True: Validation, False: Validation, True.Value == False.Value {

  public func validate(_ value: True.Value) throws {
    switch self {
    case let .first(first):
      try first.validate(value)
    case let .second(second):
      try second.validate(value)
    }
  }
}

extension _Conditional: AsyncValidator
where True: AsyncValidator, False: AsyncValidator, True.Value == False.Value {

  public func validate(_ value: True.Value) async throws {
    switch self {
    case let .first(first):
      try await first.validate(value)
    case let .second(second):
      try await second.validate(value)
    }
  }
}
extension _SequenceMany: Validation where V: Validation {

  @inlinable
  public func validate(_ value: V.Value) throws {
    switch self {
    case let .accumulating(validators):
      var errors = [Error]()

      for validator in validators {
        call(&errors) {
          try validator.validate(value)
        }
      }

      guard errors.isEmpty else {
        throw ValidationError.manyFailed(errors)
      }

    case let .failEarly(validators):
      for validator in validators {
        try validator.validate(value)
      }

    case let .oneOf(validators):
      for validator in validators {
        do {
          try validator.validate(value)
          return
        }
      }
    //      throw ValidationError.failed(summary: "Is not `OneOf` validate values.")
    }
  }
}

extension _Sequence: Validation where V0: Validation, V1: Validation, V0.Value == V1.Value {

  @inlinable
  public func validate(_ value: V0.Value) throws {
    switch self {
    case let .accumulating(validator0, validator1):
      var errors = [Error]()
      call(&errors) {
        try validator0.validate(value)
      }
      call(&errors) {
        try validator1.validate(value)
      }
      guard errors.isEmpty else {
        throw ValidationError.manyFailed(errors)
      }

    case let .failEarly(validator0, validator1):
      try validator0.validate(value)
      try validator1.validate(value)

    case let .oneOf(validator0, validator1):
      do {
        try validator0.validate(value)
        return  // succeed.
      } catch {
        try validator1.validate(value)
      }
    }
  }
}

extension _SequenceMany: AsyncValidator where V: AsyncValidator {

  @inlinable
  public func validate(_ value: V.Value) async throws {
    switch self {
    case let .accumulating(validators):
      var errors = [Error]()

      for validator in validators {
        await callAsync(&errors) {
          try await validator.validate(value)
        }
      }

      guard errors.isEmpty else {
        throw ValidationError.manyFailed(errors)
      }

    case let .failEarly(validators):
      for validator in validators {
        try await validator.validate(value)
      }

    case let .oneOf(validators):
      for validator in validators {
        do {
          try await validator.validate(value)
          return
        }
      }
    //      throw ValidationError.failed(summary: "Is not `OneOf` validate values.")
    }

  }
}

extension _Sequence: AsyncValidator
where V0: AsyncValidator, V1: AsyncValidator, V0.Value == V1.Value {

  @inlinable
  public func validate(_ value: V0.Value) async throws {
    switch self {
    case let .accumulating(validator0, validator1):
      var errors = [Error]()
      await callAsync(&errors) {
        try await validator0.validate(value)
      }
      await callAsync(&errors) {
        try await validator1.validate(value)
      }
      guard errors.isEmpty else {
        throw ValidationError.manyFailed(errors)
      }

    case let .failEarly(validator0, validator1):
      try await validator0.validate(value)
      try await validator1.validate(value)

    case let .oneOf(validator0, validator1):
      do {
        try await validator0.validate(value)
        return  // succeed.
      } catch {
        try await validator1.validate(value)
      }
    }
  }
}

@usableFromInline
func call(_ errors: inout [Error], _ closure: @escaping () throws -> Void) {
  do {
    try closure()
  } catch {
    errors.append(error)
  }
}

@usableFromInline
func callAsync(_ errors: inout [Error], _ closure: @escaping () async throws -> Void) async {
  do {
    try await closure()
  } catch {
    errors.append(error)
  }
}
