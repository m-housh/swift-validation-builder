# ``Validations``

A library for creating validations with a focus on performance and ergonomics.

## Additional Resources
- [Github Repo](https://github.com/m-housh/swift-validation-builder)

## Overview

Validations with this library can be built by declaring ``Validation`` types, using the built-in
types supplied with the library, or conforming your types to the ``Validatable`` protocol.

### Using Validator's

Below is an example of using a validator that you define for a given type.

```swift
struct User { 
  let name: String
  let email: String
}

let userValidator = ValidatorOf<User> {  

  Validator.validate(\.name, using: String.notEmpty())
  Validator.validate(\.email) { 
    String.notEmpty()
    String.contains("@")
  }
}

try userValidator.validate(User(name: "Blob", email: "blob@example.com")) // success.
try userValidator.validate(User(name: "", email: "blob@example.com")) // throws error.
try userValidator.validate(User(name: "Blob", email: "blob.example.com")) // throws error.

```

>  ``ValidatorOf`` is typealias of ``Validator`` for better ergonomics,
>  however the above could also be written as `Validator<User>` if
>  you'd prefer.

### Conforming to `Validatable`

You can conform types to the ``Validatable`` protocol or ``AsyncValidatable``, 
which are types that can validate an instance of itself.

Generally you will supply the ``Validation/body-swift.property-2e4vc`` property.  Which uses
result builder syntax.

```swift
extension User: Validatable { 

  var body: some Validator<Self> { 
    Validator { 
      Validator.validate(\.name, using: String.notEmpty())
      Validator.validate(\.email) { 
        String.notEmpty()
        String.contains("@")
      }
    }
  }

}

try User(name: "Blob", email: "blob@example.com").validate() // success.
try User(name: "", email: "blob@example.com").validate() // throws error.
try User(name: "Blob", email: "blob.example.com").validate() // throws error.
```

However you can also implement the ``Validation/validate(_:)-lqpu``.

```swift
enum UserError: Error { 
  case invalidName
}

extension User: Validatable { 
  
  func validate(_ value: User) throws { 
    guard value.name != "" else {  
      throw UserError.invalidName
    }
  }
}

```

## Topics

### Articles

- <doc:GettingStarted>
- <doc:Validation-Types>

### Validation Protocols

- ``Validation``
- ``AsyncValidation``
- ``Validatable``
- ``AsyncValidatable``

### Concrete Validation Types

- ``Validator``
- ``AsyncValidator``
- ``AnyValidator``
- ``AnyAsyncValidator``
- ``Validators``

### Builder Types

- ``AccumulatingErrorBuilder``
- ``AsyncValidationBuilder``
- ``OneOfBuilder``
- ``ValidationBuilder``
