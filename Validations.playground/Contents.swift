import Validations

var greeting = "Hello, playground"

struct Deeply {
  let nested = Nested()
  struct Nested {
    let value = 10
  }
}

struct Parent {
  let count: Int
  let deeply = Deeply()
}

let countValidator = ValidatorOf<Parent> {
  Equals({ $0.count}, { $0.deeply.nested.value })
}

try countValidator.validate(.init(count: 10)) // success.
try countValidator.validate(.init(count: 11)) // fails.
