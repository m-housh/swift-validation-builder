import Validations
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

let validator = Int.greaterThan(0).errorLabel("My Int")

try validator.validate(-1)
