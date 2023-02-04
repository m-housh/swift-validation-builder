//import Validations
import Foundation

var greeting = "Hello, playground"

//struct MatchCharacter: Validatable {
//  let input: String
//  let character: Character
//
//  var body: some Validation<Self> {
//    Validator.contains(\.input, \.character)
//  }
//}
//
//try MatchCharacter(input: "blob around the world", character: "a").validate() // success.
//try MatchCharacter(input: "blob jr.", character: "z").validate() // fails.

var optional: Optional<Int> = .some(1)

struct User {
  let name: String
}

//let keyPath = \User.name
