# Validation Types

Learn about the top level validation types and their differences.

## Overview

There are several top level `resultBuilder` types that can be used to control how values are
validated.  The same methods are implemented on both the ``AsyncValidator`` and the ``Validator`` 
types, so the examples will mostly apply to both.


The primary builder, when calling an `init` method fails upon the first error.  Depending
on your use case, you may or may not need to gather errors from downstream validations.

### Example

```swift

let validator = ValidatorOf<User> { 

  Validator.validate(\.id, with: .greaterThan(0))
    .errorLabel("Id", inline: true)

  Validator.validate(\.name, with: .notEmpty())
    .errorLabel("Name", inline: true)

  Validator.validate(\.isAdmin, with: true)
    .errorLabel("Admin", inline: true)
}

try validator.validate(.init(id: 1, name: "", isAdmin: false))

// Fails with one error for name.
//
// "Name: Expected to not be empty."
```

If you need a validation that accumulates all the errors from the validations, then
you can use one of the `accumulating` methods.

```swift

let validator = ValidatorOf<User>.accumulating { 

  Validator.validate(\.id, with: .greaterThan(0))
    .errorLabel("Id", inline: true)

  Validator.validate(\.name, with: .notEmpty())
    .errorLabel("Name", inline: true)

  Validator.validate(\.isAdmin, with: true)
    .errorLabel("Admin", inline: true)
}

try validator.validate(.init(id: 1, name: "", isAdmin: false))

// Fails with 2 errors.
//
// "Name: Expected to not be empty.
//
//  Admin: Expected true."
```

There is also a `oneOf` method that ensures that at least one of the validations
succeeds.

```swift

let blobOrBlobJr = ValidatorOf<String>.oneOf { 
  String.equals("Blob")
  String.equals("Blob Jr.")
}

try blobOrBlobJr.validate("Blob Jr.") // success.
try blobOrBlobJr.validate("Blob") // success.
try blobOrBlobJr.validate("Blob Sr.") // fails.

```

### Async Differences

In general the builders for the ``AsyncValidator`` type work the same, however
some of the extension on foundation types, such as `String`, `Comparable`, and `Collection`
only return synchronous validators by default. Under the hood the builder will convert them
to ``AsyncValidation``'s, if the compiler complains then it is safer to just directly call
the `async` method on those types or use the equivalent static method on the ``AsyncValidator``.

**Example**

```swift
// below compiles fine.

let emailValidator = AsyncValidatorOf<String> { 
  String.notEmpty()
  String.email()
}


// below also compiles fine, but is more verbose.
let emailValidator2 = AsyncValidatorOf<String> { 
  String.notEmpty().async()
  String.email().async()
}

// below would be the safest way, but is also more verbose.
let emailValidato3 = AsyncValidatorOf<String> { 
  AsyncValidator.notEmpty()
  AsyncValidator.email()
}

```

