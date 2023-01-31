import Validations

var greeting = "Hello, playground"

struct User: Validatable {
  let name: String
  let email: String
  
  var body: some Validator<Self> {
    Validation.accumulating {
      Validate(\.name) {
        OneOf {
          Equals("Blob")
          Equals("Blob Jr.")
        }
      }
//      Validate(\.name, using: NotEmpty())
      Validate(\.email) {
        NotEmpty()
        Contains("@")
      }
    }
  }
}
//
//let blobOrBlobJrValidator = Validation<String>.oneOf {
//  Equals("Blob")
//  Equals("Blob Jr.")
//}
//
//
try User(name: "blob", email: "blob@example.com").validate()
//try User(name: "", email: "blob.example.com").validate()
//try blobOrBlobJrValidator.validate("Blob")
//try blobOrBlobJrValidator.validate("Blob Jr.")
//try blobOrBlobJrValidator.validate("Blob Sr.")
