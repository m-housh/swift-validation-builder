# swift-validations

[![CI](https://github.com/m-housh/swift-validations/actions/workflows/ci.yml/badge.svg)](https://github.com/m-housh/swift-validations/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm-housh%2Fswift-validations%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/m-housh/swift-validations)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm-housh%2Fswift-validations%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/m-housh/swift-validations)

A swift package for creating validations, using `ResultBuilder` syntax.

## Additional Resources

- [Github Repo](https://github.com/m-housh/swift-validations)
- [Documentation](https://m-housh.github.io/swift-validations/documentation/validations)

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

## Documentation

Read the api documentation [here](https://m-housh.github.io/swift-validations/documentation/validations).
