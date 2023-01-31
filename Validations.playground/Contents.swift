import Validations

var greeting = "Hello, playground"

struct User {
  let id: Int
  let name: String
  let isAdmin: Bool
}

extension User: Validatable {
  
  var body: some Validator<Self> {
    Accumulating {
      GreaterThan(\.id, 0)
      Validate(\.name, using: NotEmpty())
    }
  }
}

let adminUserValidator = ValidatorOf<User> {
  Accumulating {
    Validate(\.self)
    Validate(\.isAdmin, using: True())
  }
}

//try User(id: 1, name: "blob", isAdmin: true).validate()
//try User(name: "", email: "blob.example.com").validate()
//try blobOrBlobJrValidator.validate("Blob")
//try blobOrBlobJrValidator.validate("Blob Jr.")
//try blobOrBlobJrValidator.validate("Blob Sr.")
