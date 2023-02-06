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
        Validator.accumulating {
          Validator.validate(\.id, with: Int.greaterThan(0))
          Validator.validate(\.name, with: String.notEmpty())
        }
      }
    }

    let adminUserValidator = ValidatorOf<User> {
      Validator.accumulating {
        Validator.validate(\.self)
        Validator.validate(\.isAdmin, with: true)
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
      let expected = """
       Failed bool evaluation, expected true
       0 is not greater than 0
       Expected to not be empty.
       
       """
      XCTAssertNoDifference(error.debugDescription, expected)
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
    
    let sut = ValidatorOf<MatchCharacter>.contains(\.input, element: "z")
    XCTAssertNoThrow(try sut.validate(.init(input: "baz", character: "f")))
    XCTAssertThrowsError(try sut.validate(.init(input: "foo", character: "f")))
  
  }
  
  func test_comparable() {
    struct Deeply {
      let nested = Nested()
      
      struct Nested {
        let value = 10
      }
    }
    
    struct Example {
      let count: Int
      let deeply = Deeply()
    }
    
    let intValidator: ValidatorOf<Int> = Int.greaterThan(10)
    XCTAssertNoThrow(try intValidator.validate(11))
    XCTAssertThrowsError(try intValidator.validate(9))
    
    let sut2: ValidatorOf<Int> = Int.greaterThanOrEquals(10)
    XCTAssertNoThrow(try sut2.validate(10))
    XCTAssertThrowsError(try sut2.validate(9))
    
    let sut3 = ValidatorOf<Example>.lessThan(\.count, \.deeply.nested.value)
    XCTAssertNoThrow(try sut3.validate(.init(count: 9)))
    XCTAssertThrowsError(try sut3.validate(.init(count: 11)))
    
    let sut4 = ValidatorOf<Example>.lessThan(10, \.count)
    XCTAssertNoThrow(try sut4.validate(.init(count: 11)))
    XCTAssertThrowsError(try sut4.validate(.init(count: 9)))
    
    let sut5 = ValidatorOf<Example>
      .lessThanOrEquals({ $0.count }, { $0.deeply.nested.value })
    XCTAssertNoThrow(try sut5.validate(.init(count: 10)))
    XCTAssertThrowsError(try sut5.validate(.init(count: 11)))
    
    let sut6 = ValidatorOf<Example>
      .lessThanOrEquals(\.count, 10)
    XCTAssertNoThrow(try sut6.validate(.init(count: 10)))
    XCTAssertThrowsError(try sut6.validate(.init(count: 11)))

    
    let sut7 = ValidatorOf<Example>
      .lessThanOrEquals(10, \.count)
    XCTAssertNoThrow(try sut7.validate(.init(count: 10)))
    XCTAssertThrowsError(try sut7.validate(.init(count: 9)))
    
    let sut8 = ValidatorOf<Example>.greaterThan(\.count, \.deeply.nested.value)
    XCTAssertNoThrow(try sut8.validate(.init(count: 11)))
    XCTAssertThrowsError(try sut8.validate(.init(count: 9)))
  }
  
  func test_error_label() throws {
    let validator: some Validation<Int> = Int.greaterThan(0).errorLabel("My Int", inline: true)
    do {
      try validator.validate(-1)
    } catch {
      let error = error as! ValidationError
      let expected = "My Int: -1 is not greater than 0"
      XCTAssertEqual(error.debugDescription, expected)
    }
  }
  
  func test_async_validation_doc() async {
    
    struct User {
      let name: String
      let email: String
    }
    
    struct BlobValidator: AsyncValidation {
      typealias Value = User
      
      var body: some AsyncValidation<User> {
        AsyncValidator {
          AsyncValidator.validate(\.name, with: .equals("Blob"))
          AsyncValidator.validate(\.email, with: .equals("blob@example.com"))
        }
      }
    }
    
    let blob = User(name: "Blob", email: "blob@example.com")
    let notBlob = User(name: "Blob Jr.", email: "blob.jr@example.com")
    
    let validator = BlobValidator()
    
    await XCTAssertNoThrowAsync(try await validator.validate(blob)) // success.
    await XCTAssertThrowsAsyncError(try await validator.validate(notBlob)) // throws.
  }
}
