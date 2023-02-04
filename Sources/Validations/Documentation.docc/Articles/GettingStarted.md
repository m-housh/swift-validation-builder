#  Getting Started

Learn how to integrate Validations into your project.

## Overview

Learn how to integrate Validations into your project and create your first `Validator`.

### Adding Validations as a dependency

To use the Validations library in a SwiftPM project, add it to the dependencies of your Package.swift
and specify the `Validations` product in any targets that need access to the library.

```swift

let package = Package(
  dependencies: [
    .package(url: "https://github.com/m-housh/swift-validation-builder", from: "0.2.0")
  ],
  targets: [
    .target(
      name: "<target name>",
      dependencies: [
        .product(name: "Validations", package: "swift-validation-builder")
      ]
    )
  ]
)
```

### Your first validator.

Suppose you have a `User`'s type that you'd like to validate.

```swift
struct User { 
  let id: Int
  let name: String
  let isAdmin: Bool
}
```

Let's create a validator that will validate that the name is not an empty string,
and that the id is greater than 0.

Generally you may declare a function that can handle this for you and throw errors,
if the user does not pass.

```swift
enum UserError: Error { 
  case invalidId
  case invalidName
}

func userValidator(_ user: User) throws { 

  // check the id is greater than 0.
  guard user.id > 0 else { 
    throw UserError.invalidId
  }
 
  // check that the name is not an empty string.
  guard user.name != "" else { 
    throw UserError.invalidName
  }

}
```

Let's look at how we can accomplish the same thing with the `Validations` library.


```swift
let userValidator = ValidatorOf<User> { 

  // check the id is greater than 0.
  Validators.Validate(\.id, with: Int.greaterThan(0))

  // check that the name is not an empty string.
  Validators.Validate(\.name, with: String.notEmpty())
}

try userValidator.validate(User(id: 1, name: "Blob", isAdmin: false)) // success
try userValidator.validate(User(id: 0, name: "Blob Jr.", isAdmin: true)) // fails

```

Now that we've created a basic user validator, suppose we want a way to validate admin
users.

Here's how that may look when we create our own function to handle that.

```swift

struct AdminUserError: Error { }

func adminUserValidator(_ user: User) throws { 

  // do the basic checks first.
  try userValidator(user)

  guard user.isAdmin else {   
    throw AdminUserError()
  }

}
```

Notice how we had to create another `Error` type, we were able to re-use our basic validation.

Now let's look at how we can compose our previous `Validator` with one that checks the `isAdmin`
property.

```swift

let adminUserValidator = ValidatorOf<User> {
  
  // make sure that we pass the basic validations.
  Validators.Validate(\.self, with: userValidator)

  // now test that the user is an admin.
  Validators.Validate(\.isAdmin, with: true)
}

try adminUserValidator.validate(User(id: 1, name: "Blob", isAdmin: true)) // success
try adminUserValidator.validate(User(id: 2, name: "Blob Jr.", isAdmin: false)) // fails

```

There is not a ton of difference, however let's imagine that we discovered that we
need to do all the validations and accumulate the errors.  I will not re-create the functions,
however I will show how easy this can be implemented by using the ``Validator/accumulating(accumulating:)`` 
validator that is supplied with the library.

```swift

// You can create using a static method on the `Validator` type.
let userValidator = ValidatorOf<User>.accumulating { 
  Validators.Validate(\.id, with: Int.greaterThan(0))
  Validators.Validate(\.name, with: String.notEmpty())
}

// Or use the `Accumulating` type directly.
let adminUserValidator = ValidatorOf<User> { 
  Validators.Accumulating { 
    Validators.Validate(\.self, with: userValidator)
    Validators.Validate(\.isAdmin, with: true)
  }
}

try adminUserValidator.validate(User(id: 1, name: "Blob", isAdmin: true)) // success
try adminUserValidator.validate(User(id: 0, name: "", isAdmin: false)) // fails with 3 errors accumulated.

```

### Conform your types to the `Validatable` protocol.

You can also conform your types to the ``Validatable`` protocol.  A `Validatable` type is able
to validate an instance of itself.

This has the advantage of using the ``Validation/body-swift.property-2e4vc`` property for a clean
interface, using result builder syntax as shown above.

```swift
extension User: Validatable {
  
  var body: some Validator<Self> { 
    Validators.Accumulating { 
      Validators.Validate(\.id, with: .greaterThan(0))
      Validators.Validate(\.name, with: .notEmpty())
    }
  }
}

let adminUserValidator = ValidatorOf<User>.accumulating { 
  Validators.Validate(\.self)
  Validators.Validate(\.isAdmin, with: true)
}
```
