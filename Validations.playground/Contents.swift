import Validations

var greeting = "Hello, playground"

struct User: Validatable {
  let name: String
  let email: String
  
  var body: some Validator<Self> {
    Validation.accumulating {
      Validate(\.name, using: NotEmpty())
      Validate(\.email) {
        NotEmpty()
        Contains("@")
      }
    }
  }
}

try User(name: "blob", email: "blob@example.com").validate()
try User(name: "", email: "blob.example.com").validate()
