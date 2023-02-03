# ``Validations``

A library for creating validations with a focus on performance and ergonomics.

## Additional Resources
- [Github Repo](https://github.com/m-housh/swift-validation-builder)

## Overview

Validations with this library can be built by declaring ``Validator`` types, using the built-in
types supplied with the library, or conforming your types to the ``Validatable`` protocol.

### Using Validator's

Below is an example of using a validator that you define for a given type.

```swift
struct User { 
  let name: String
  let email: String
}

let userValidator = ValidatorOf<User> {  

  Validate(\.name, using: NotEmpty())
  Validate(\.email) { 
    NotEmpty()
    Contains("@")
  }
}

try userValidator.validate(User(name: "Blob", email: "blob@example.com")) // success.
try userValidator.validate(User(name: "", email: "blob@example.com")) // throws error.
try userValidator.validate(User(name: "Blob", email: "blob.example.com")) // throws error.

```

>  ``ValidatorOf`` is typealias of ``Validation`` for better ergonomics,
>  however the above could also be written as `Validation<User>` if
>  you'd prefer.

### Conforming to `Validatable`

You can conform types to the ``Validatable`` protocol, which is a type that can
validate an instance of itself.

Generally you will supply the ``Validation/body-swift.property-2e4vc`` property.  Which uses
result builder syntax.

```swift
extension User: Validatable { 

  var body: some Validator<Self> { 
    Validation { 
      Validate(\.name, using: NotEmpty())
      Validate(\.email) { 
        NotEmpty()
        Contains("@")
      }
    }
  }

}

try User(name: "Blob", email: "blob@example.com").validate() // success.
try User(name: "", email: "blob@example.com").validate() // throws error.
try User(name: "Blob", email: "blob.example.com").validate() // throws error.
```

However you can also implement the ``Validation/body-swift.property-7hgef``.

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

* <doc:GettingStarted>

### Validation Types

* ``Validation``
* ``Validatable``
* ``AsyncValidation``
* ``AsyncValidatable``
