
public enum _Sequence<V0, V1> {
  case accumulating(V0, V1)
  case earlyOut(V0, V1)
  case oneOf(V0, V1)
}

public enum _SequenceMany<V> {
  case accumulating([V])
  case earlyOut([V])
  case oneOf([V])
}

public enum _Conditional<True, False> {
  case first(True)
  case second(False)
}

extension _Conditional: Validator where True: Validator, False: Validator, True.Value == False.Value {
  
  public func validate(_ value: True.Value) throws {
    switch self {
    case let .first(first):
      try first.validate(value)
    case let .second(second):
      try second.validate(value)
    }
  }
}

extension _Conditional: AsyncValidator where True: AsyncValidator, False: AsyncValidator, True.Value == False.Value {
  
  public func validate(_ value: True.Value) async throws {
    switch self {
    case let .first(first):
      try await first.validate(value)
    case let .second(second):
      try await second.validate(value)
    }
  }
}
extension _SequenceMany: Validator where V: Validator {
  
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
      
    case let .earlyOut(validators):
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

extension _Sequence: Validator where V0: Validator, V1: Validator, V0.Value == V1.Value {

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
      
    case let .earlyOut(validator0, validator1):
      try validator0.validate(value)
      try validator1.validate(value)
      
    case let .oneOf(validator0, validator1):
      do {
        try validator0.validate(value)
        return // succeed.
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
      
    case let .earlyOut(validators):
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

extension _Sequence: AsyncValidator where V0: AsyncValidator, V1: AsyncValidator, V0.Value == V1.Value {

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
      
    case let .earlyOut(validator0, validator1):
      try await validator0.validate(value)
      try await validator1.validate(value)
      
    case let .oneOf(validator0, validator1):
      do {
        try await validator0.validate(value)
        return // succeed.
      } catch {
        try await validator1.validate(value)
      }
    }
  }
}

@usableFromInline
func call(_ errors: inout [Error], _ closure: @escaping () throws -> ()) {
  do {
    try closure()
  } catch {
    errors.append(error)
  }
}

@usableFromInline
func callAsync(_ errors: inout [Error], _ closure: @escaping () async throws -> ()) async {
  do {
    try await closure()
  } catch {
    errors.append(error)
  }
}
