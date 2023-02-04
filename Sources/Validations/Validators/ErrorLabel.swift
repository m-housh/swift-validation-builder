extension Validation {
  
  public func errorLabel(_ label: String, inline: Bool = false) -> Validators.ErrorLabelValidator<Self> {
    .init(label: label, inlineLabel: inline, validator: self)
  }
  
}

extension AsyncValidation {
  
  public func errorLabel(_ label: String, inline: Bool = false) -> Validators.ErrorLabelValidator<Self> {
    .init(label: label, inlineLabel: inline, validator: self)
  }
  
}

extension Validators {
  
  public struct ErrorLabelValidator<Validator> {
  
    public let label: String
    public let inlineLabel: Bool
    public let validator: Validator
    
    @inlinable
    public init(
      label: String,
      inlineLabel: Bool,
      validator: Validator
    ) {
      self.label = label
      self.inlineLabel = inlineLabel
      self.validator = validator
    }
  }
}

extension Validators.ErrorLabelValidator: Validation where Validator: Validation {
  
  @inlinable
  public func validate(_ value: Validator.Value) throws {
    do {
      try self.validator.validate(value)
    } catch {
      throw ValidationError.failed(label: label, error: error, inlineLabel: inlineLabel)
    }
  }
}

extension Validators.ErrorLabelValidator: AsyncValidation where Validator: AsyncValidation {
  
  @inlinable
  public func validate(_ value: Validator.Value) async throws {
    do {
      try await self.validator.validate(value)
    } catch {
      throw ValidationError.failed(label: label, error: error)
    }
  }
}
