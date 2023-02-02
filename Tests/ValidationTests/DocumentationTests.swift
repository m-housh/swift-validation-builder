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
}
