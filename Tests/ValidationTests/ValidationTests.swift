import XCTest
import CasePaths
@testable import Validations

final class ValidationTests: XCTestCase {
  
  func testSanity() {
    XCTAssert(true)
  }
  
  func test_or_validator() throws {
    let validators = [
      ValidatorOf<Int> {
        Always<Int>()
        GreaterThan(10).or(Equals(5))
      },
      Validation {
        Equals(5).or(GreaterThan(10))
      },
      Validation {
        Equals(5).or {
          GreaterThan(10)
        }
      }
    ]
    
    for validator in validators {
      XCTAssertNoThrow(try validator.validate(11))
      XCTAssertNoThrow(try validator.validate(5))
      XCTAssertThrowsError(try validator.validate(4))
    }
    
    XCTAssertNoThrow(try validators.validator().validate(11))
  }
  
  func test_empty() throws {
    let emptyString = ValidatorOf<String> {
      Empty<String>()
    }
    
    XCTAssertNoThrow(try emptyString.validate(""))
    XCTAssertThrowsError(try emptyString.validate("foo"))
  }
  
  func test_notEmpty() {
    let notEmptyString = ValidatorOf<String> {
      NotEmpty()
    }
    
    XCTAssertNoThrow(try notEmptyString.validate("foo"))
    XCTAssertThrowsError(try notEmptyString.validate(""))
  }
  
  func test_contains_validator() throws {
    let validator = ValidatorOf<String> {
      Contains("@")
    }
    
    XCTAssertNoThrow(try validator.validate("foo@bar.com"))
    XCTAssertThrowsError(try validator.validate("foo.bar.com"))
    
    struct Sut {
      let one: [String]
      let two: String
    }
    
    let sut = ValidatorOf<Sut> {
      Contains(\.one, \.two)
    }
    
    XCTAssertNoThrow(
      try sut.validate(.init(one: ["foo", "bar"], two: "foo"))
    )
    XCTAssertThrowsError(try sut.validate(.init(one: ["baz", "bar"], two: "foo")))
  }
  
  func test_greater_than_validator() throws {

    let validator = ValidatorOf<Int> {
      GreaterThan(10)
      GreaterThan(\.zero)
    }
    
    XCTAssertNoThrow(try validator.validate(11))
    XCTAssertThrowsError(try validator.validate(10))
    
    struct Sut {
      let one: Int
      let two: Int
    }
  
    let sut = ValidatorOf<Sut> {
      GreaterThan(\.one, \.two)
      Validate(\.one) {
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        GreaterThan(10)
        Not(GreaterThan(15))
      }
      GreaterThan(50, \.two)
    }
    
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 10)))
    XCTAssertThrowsError(try sut.validate(.init(one: 11, two: 12)))
    XCTAssertThrowsError(try sut.validate(.init(one: 10, two: 9)))
    XCTAssertThrowsError(try sut.validate(.init(one: 11, two: 51)))
    
  }
  
  func test_lessThan() {
      
    struct Sut: Validatable {
      let one: Int
      let two: Int
      
      var body: some Validator<Self> {
        Validation {
          LessThan(\.one, 12)
          LessThanOrEquals(\.one, \.two)
          LessThan(1, \.two)
          LessThan(\.one, \.two).or {
            Equals(\.one, \.two)
          }
          LessThanOrEquals(\.one, 13)
        }
      }
    }
    
    XCTAssertThrowsError(try Sut(one: 13, two: 13).validate())
    XCTAssertThrowsError(try Sut(one: 3, two: 2).validate())
    XCTAssertNoThrow(try Sut(one: 10, two: 11).validate())
    
    let lessThanOrEqualsOne = ValidatorOf<Int> {
      LessThanOrEquals(1)
    }
    
    XCTAssertThrowsError(try lessThanOrEqualsOne.validate(2))
    XCTAssertNoThrow(try lessThanOrEqualsOne.validate(1))
    
    let lessThan12 = ValidatorOf<Int> {
      LessThan(12)
    }
    
    XCTAssertThrowsError(try lessThan12.validate(12))
    XCTAssertNoThrow(try lessThan12.validate(11))
    
  }
  
  func test_greater_than_or_equals_validator() throws {
    let validator = ValidatorOf<Int> {
      GreaterThanOrEquals(10)
    }
    
    XCTAssertNoThrow(try validator.validate(10))
    XCTAssertThrowsError(try validator.validate(9))
    
    struct Sut {
      let one: Int
      let two: Int
    }
  
    let sut = ValidatorOf<Sut> {
      GreaterThanOrEquals(\.one, \.two)
    }
    
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 10)))
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 11)))
    XCTAssertThrowsError(try sut.validate(.init(one: 10, two: 11)))
  }
  
  func test_not_validator() throws {
    
    let validator = ValidatorOf<Int> {
      Not {
        GreaterThan(0)
      }
    }
    
    XCTAssertThrowsError(try validator.validate(4))
    XCTAssertNoThrow(try validator.validate(-1))
  }
  
  func test_validatable() throws {
    struct Sut: Validatable {
      let one: Int
      let two: Int
      
      var body: some Validator<Self> {
        Equals(\.one, \.two)
      }
    }
    
    XCTAssertNoThrow(try Sut(one: 1, two: 1).validate())
    XCTAssertThrowsError(try Sut(one: 1, two: 2).validate())
  }
  
  func test_concurrency() async {
    struct Sut: AsyncValidatable {
      
      let one: Int
      let two: Int
      
      var body: some AsyncValidator<Self> {
        AsyncValidation {
          LessThan(\.one, 12)
          LessThanOrEquals(\.one, \.two)
          LessThan(1, \.two)
        }
      }
    }
    
    await XCTAssertThrowsAsyncError(try await Sut(one: 13, two: 13).validate())
    await XCTAssertThrowsAsyncError(try await Sut(one: 3, two: 2).validate())
  }
  
  func test_case() throws {
    enum Sut: Equatable {
      case one(Int)
      case two(Int)
      case three(Int)
    }
    
    let sut = OneOf {
      Case(/Sut.one, using: GreaterThan(0))
      Case(/Sut.two) {
        GreaterThan(10)
      }
    }
    
    XCTAssertThrowsError(try sut.validate(.one(0)))
    XCTAssertThrowsError(try sut.validate(.two(0)))
    XCTAssertThrowsError(try sut.validate(.three(0)))
    XCTAssertNoThrow(try sut.validate(.one(1)))
    XCTAssertNoThrow(try sut.validate(.two(11)))
  }
  
  func test_oneOF() throws {
    let sut = OneOf {
      GreaterThan(0)
      Equals(-10)
    }
    
    XCTAssertThrowsError(try sut.validate(-1))
    XCTAssertNoThrow(try sut.validate(-10))
    XCTAssertNoThrow(try sut.validate(1))
    
    let sut2 = ValidatorOf<Int> {
      OneOf {
        GreaterThan(0)
        Equals(-10)
      }
    }
    XCTAssertThrowsError(try sut2.validate(-1))
    XCTAssertNoThrow(try sut2.validate(-10))
    XCTAssertNoThrow(try sut2.validate(1))
    
  }
  
  func test_documenation() {
    
    struct User: Validatable {
      
      let name: String
      let email: String
      
      var body: some Validator<Self> {
        Accumulating {
          Validate(\.name, using: NotEmpty())
          Validate(\.email) {
            Accumulating {
              NotEmpty()
              Contains("@")
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try User(name: "blob", email: "blob@example.com").validate())
    XCTAssertThrowsError(try User(name: "", email: "blob@example.com").validate())
    
    struct HoldsUser: Validatable {
      let user: User
      
      var body: some Validator<Self> {
        Validate(\.user)
      }
    }
    
    XCTAssertNoThrow(try HoldsUser(user: .init(name: "blob", email: "blob@example.com")).validate())
    XCTAssertThrowsError(try HoldsUser(user: .init(name: "blob", email: "blob.example.com")).validate())
  }
  
  func test_builder_either() {
   
    struct Sut: Validator {
      
      typealias Value = String
      
      let onlyBlobs: Bool
      
      var body: some Validator<String> {
        Validation {
          if onlyBlobs {
            Equals("Blob")
          } else {
            NotEmpty()
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(onlyBlobs: false).validate("foo"))
    XCTAssertThrowsError(try Sut(onlyBlobs: false).validate(""))
    
    XCTAssertNoThrow(try Sut(onlyBlobs: true).validate("Blob"))
    XCTAssertThrowsError(try Sut(onlyBlobs: true).validate("foo"))
    
  }
  
  func test_builder_if() {
   
    struct Sut: Validator {
      
      typealias Value = String
      
      let onlyBlobs: Bool
      
      var body: some Validator<String> {
        Validation {
          Always()
          if onlyBlobs {
            Equals("Blob")
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(onlyBlobs: false).validate("foo"))
    XCTAssertNoThrow(try Sut(onlyBlobs: true).validate("Blob"))
    XCTAssertThrowsError(try Sut(onlyBlobs: true).validate("foo"))
    
  }
  
  func test_accumulating_errors() {
    struct User: Validatable {
      let name: String
      let email: String
      
      var body: some Validator<Self> {
        Accumulating {
          Validate(\.name, using: NotEmpty())
          Validate(\.email) {
            NotEmpty()
            Contains("@")
          }
        }
      }
    }

    XCTAssertNoThrow(try User(name: "blob", email: "blob@example.com").validate())
    do {
      try User(name: "", email: "blob.example.com").validate()
    } catch {
      guard case let .manyFailed(validationErrors, _) = error as! ValidationError else {
        XCTFail()
        return
      }
      XCTAssertEqual(validationErrors.count, 2)
    }
  }
  
  func test_true_validator() {
    
    let isTrue = ValidatorOf<Bool> {
      True()
    }
    
    XCTAssertNoThrow(try isTrue.validate(true))
    XCTAssertThrowsError(try isTrue.validate(false))
    
    struct User: Validatable {
      let name: String
      let email: String
      let isAdmin: Bool
      
      var body: some Validator<Self> {
        Accumulating {
          Validate(\.isAdmin, using: True())
        }
      }
    }
    
    XCTAssertNoThrow(try User(name: "Blob", email: "blob@example.com", isAdmin: true).validate())
    XCTAssertThrowsError(try User(name: "Blob", email: "blob@example.com", isAdmin: false).validate())
    
  }
  
  func test_false_validator() {
    
    let isFalse = ValidatorOf<Bool> {
      False()
    }
    
    XCTAssertNoThrow(try isFalse.validate(false))
    XCTAssertThrowsError(try isFalse.validate(true))
    
    struct User: Validatable {
      let name: String
      let email: String
      let isAdmin: Bool
      
      var body: some Validator<Self> {
        Accumulating {
          Validate(\.isAdmin, using: False())
        }
      }
    }
    
    XCTAssertNoThrow(try User(name: "Blob", email: "blob@example.com", isAdmin: false).validate())
    XCTAssertThrowsError(try User(name: "Blob", email: "blob@example.com", isAdmin: true).validate())
    
  }
  
}

extension Int {
  var zero: Int { 0 }
}

