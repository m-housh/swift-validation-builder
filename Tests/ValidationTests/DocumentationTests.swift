import XCTest
import CustomDump
@testable import Validations

final class DocumentationTests: XCTestCase {
  
  func test_gettingStarted() throws {
    
    struct User: Validatable {
      let id: Int
      let name: String
      let isAdmin: Bool
      
      var body: some Validation<Self> {
        Accumulating {
          Int.greaterThan(\.id, 0)
          Validate(\.name, using: NotEmpty())
        }
      }
    }

    let adminUserValidator = ValidatorOf<User> {
      Accumulating {
        Validate(\.self)
        Validate(\.isAdmin, using: true)
      }
    }
    
    do {
      try adminUserValidator.validate(.init(id: 0, name: "", isAdmin: false))
    } catch {
      guard let error = error as? ValidationError else {
        XCTFail("Unkown error: \(error)")
        return
      }
      // Assert the error message is correct.
      let expected = "Validation Error:\n\t• 0 is not greater than 0\n\t• Expected to not be empty.\n\t• Failed bool evaluation, expected true"
      
      XCTAssertNoDifference(error.debugDescription, expected)
//      print(error)
    }
    
  }
  
  func test_contains_init() {
    struct MatchCharacter: Validatable {
      let input: String
      let character: Character
      
      var body: some Validation<Self> {
        Validator.contains(\.input, \.character)
      }
    }

    XCTAssertNoThrow(try MatchCharacter(input: "blob around the world", character: "a").validate())
    XCTAssertThrowsError(try MatchCharacter(input: "blob jr.", character: "z").validate())
    
    let containsZ = ValidatorOf<String>.contains("z")
    XCTAssertNoThrow(try containsZ.validate("baz"))
    XCTAssertThrowsError(try containsZ.validate("foo"))
    
    let hasOneValidator = ValidatorOf<[Int]>.contains(1)
    XCTAssertNoThrow(try hasOneValidator.validate([2, 3, 6, 4, 1])) // success.
    XCTAssertThrowsError(try hasOneValidator.validate([4, 9, 7, 3])) // fails
  
  }
}
