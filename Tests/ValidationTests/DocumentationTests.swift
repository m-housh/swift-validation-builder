import XCTest
@testable import Validations

final class DocumentationTests: XCTestCase {
  
  func test_gettingStarted() throws {
    
    struct User: Validatable {
      let id: Int
      let name: String
      let isAdmin: Bool
      
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
    
    do {
      try adminUserValidator.validate(.init(id: 0, name: "", isAdmin: false))
    } catch {
      print(error)
      XCTFail()
    }
    
  }
}
