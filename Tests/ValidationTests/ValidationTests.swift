import XCTest
import CasePaths
@testable import Validations

final class ValidationTests: XCTestCase {
  
  func testSanity() {
    XCTAssert(true)
  }
  
  func test_or_validator() throws {
    let validators = [
      Validator {
        Validator.always()
        Int.greaterThan(10).or(.equals(5))
      },
      Validator {
        Int.equals(5).or(.greaterThan(10))
      },
      Validator {
        Int.equals(5).or {
          Int.greaterThan(10)
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
    let sut1 = String.empty()
    let sut2 = ValidatorOf<String>.empty()
    
    XCTAssertNoThrow(try sut1.validate(""))
    XCTAssertNoThrow(try sut2.validate(""))
    XCTAssertThrowsError(try sut1.validate("foo"))
    XCTAssertThrowsError(try sut2.validate("foo"))
  }
  
  func test_notEmpty() {
    let sut1 = String.notEmpty()
    let sut2 = ValidatorOf<String>.notEmpty()
    
    XCTAssertNoThrow(try sut1.validate("foo"))
    XCTAssertNoThrow(try sut2.validate("foo"))
    XCTAssertThrowsError(try sut1.validate(""))
    XCTAssertThrowsError(try sut2.validate(""))
    
    struct Sut {
      let values: [Int]
    }
    
    let sutValidator = ValidatorOf<Sut> {
      Validate(\.values, using: .notEmpty())
    }
    
    XCTAssertNoThrow(try sutValidator.validate(.init(values: [1, 2])))
    XCTAssertThrowsError(try sutValidator.validate(.init(values: [])))
  }
  
  func test_contains_validator() throws {
    let sut1 = ValidatorOf<String>.contains("@")
    let sut2: any Validation<String> = String.contains("@")
    
    XCTAssertNoThrow(try sut1.validate("foo@bar.com"))
    XCTAssertNoThrow(try sut2.validate("foo@bar.com"))
    XCTAssertThrowsError(try sut1.validate("foo.bar.com"))
    XCTAssertThrowsError(try sut2.validate("foo.bar.com"))
    
    struct Sut {
      let one: [String]
      let two: String
    }
    
    let sut = Validator<Sut> {
      Validator.contains(\.one, \.two)
    }

    XCTAssertNoThrow(
      try sut.validate(.init(one: ["foo", "bar"], two: "foo"))
    )
    XCTAssertThrowsError(try sut.validate(.init(one: ["baz", "bar"], two: "foo")))
  }
  
  func test_greater_than_validator() throws {

    let validator = Validator {
      Int.greaterThan(10)
      Int.greaterThan(Int.zero)
    }
    
    XCTAssertNoThrow(try validator.validate(11))
    XCTAssertThrowsError(try validator.validate(10))
    
    struct Sut {
      let one: Int
      let two: Int
    }
  
    let sut = ValidatorOf<Sut> {
      Validate(\.one) {
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Not(.greaterThan(15))
      }
      Validate(\.two, using: Int.lessThan(50))
    }
    
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 10)))
    XCTAssertThrowsError(try sut.validate(.init(one: 16, two: 12)))
    XCTAssertThrowsError(try sut.validate(.init(one: 10, two: 9)))
    XCTAssertThrowsError(try sut.validate(.init(one: 11, two: 51)))
    
  }
  
  func test_lessThan() {
      
    struct Sut: Validatable {
      let one: Int
      let two: Int
      
      var body: some Validation<Self> {
        Validator {
          Validator.lessThan(\.one, 12)
          Validator.lessThanOrEquals(\.one, \.two)
          Validator.lessThan(1, \.two)
          Validate(\.one, using: Int.lessThanOrEquals(13))
        }
      }
    }
    
    XCTAssertThrowsError(try Sut(one: 13, two: 13).validate())
    XCTAssertThrowsError(try Sut(one: 3, two: 2).validate())
    XCTAssertNoThrow(try Sut(one: 10, two: 11).validate())
    
    let lessThanOrEqualsOne = ValidatorOf<Int>.lessThan(1).or(.equals(1))
    
    XCTAssertThrowsError(try lessThanOrEqualsOne.validate(2))
    XCTAssertNoThrow(try lessThanOrEqualsOne.validate(1))
    
    let lessThan12 = ValidatorOf<Int>.lessThan(12)
    
    XCTAssertThrowsError(try lessThan12.validate(12))
    XCTAssertNoThrow(try lessThan12.validate(11))
    
  }
  
  func test_greater_than_or_equals_validator() throws {
    let validator = ValidatorOf<Int>.greaterThanOrEquals(10)
    
    XCTAssertNoThrow(try validator.validate(10))
    XCTAssertThrowsError(try validator.validate(9))
    
    struct Sut {
      let one: Int
      let two: Int
    }
  
    let sut = ValidatorOf<Sut>.greaterThanOrEquals(\.one, \.two)
//    {
//
//      Int.greaterThanOrEquals(\.one, \.two)
//    }
    
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 10)))
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 11)))
    XCTAssertThrowsError(try sut.validate(.init(one: 10, two: 11)))
  }
  
  func test_not_validator() throws {
    
    let validator = ValidatorOf<Int>.not { Validator.greaterThan(0) }
    
    XCTAssertThrowsError(try validator.validate(4))
    XCTAssertNoThrow(try validator.validate(-1))
  }
  
  func test_validatable() throws {
    struct Sut: Validatable {
      let one: Int
      let two: Int
      
      var body: some Validation<Self> {
        Validator.equals(\.one, \.two)
      }
    }
    
    XCTAssertNoThrow(try Sut(one: 1, two: 1).validate())
    XCTAssertThrowsError(try Sut(one: 1, two: 2).validate())
  }
  
  func test_concurrency() async {
    struct Sut: AsyncValidatable {
      
      let one: Int
      let two: Int
      
      var body: some AsyncValidation<Self> {
        AsyncValidator {
          Validate(\.one, using: Int.lessThan(12))
//          Int.lessThan(\.one, 12)
          Validator.lessThanOrEquals(\.one, \.two)
          Validate(\.two, using: Int.lessThan(1))
//          Int.lessThan(1, \.two)
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
      Validators.Case(/Sut.one, using: .greaterThan(0))
      Validators.Case(/Sut.two) {
        Int.greaterThan(10)
      }
    }
    
    XCTAssertNoThrow(try sut.validate(.one(1)))
    XCTAssertNoThrow(try sut.validate(.two(11)))
    XCTAssertThrowsError(try sut.validate(.three(0)))
  
  }
  
  func test_oneOF() throws {
    let sut = OneOf {
      Int.greaterThan(0)
      Validator.equals(-10)
    }
    
    XCTAssertThrowsError(try sut.validate(-1))
    XCTAssertNoThrow(try sut.validate(-10))
    XCTAssertNoThrow(try sut.validate(1))
    
    let sut2 = ValidatorOf<Int> {
      OneOf {
        Validator.greaterThan(0)
        Validator.equals(-10)
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
      
      var body: some Validation<Self> {
        Accumulating {
          Validate(\.name, using: Validators.NotEmpty())
          Validate(\.email, using: .accumulating {
            String.notEmpty()
            String.contains("@")
          })
        }
      }
    }
    
    XCTAssertNoThrow(try User(name: "blob", email: "blob@example.com").validate())
    XCTAssertThrowsError(try User(name: "", email: "blob@example.com").validate())
    
    struct HoldsUser: Validatable {
      let user: User
      
      var body: some Validation<Self> {
        Validate(\.user)
      }
    }
    
    XCTAssertNoThrow(try HoldsUser(user: .init(name: "blob", email: "blob@example.com")).validate())
    XCTAssertThrowsError(try HoldsUser(user: .init(name: "blob", email: "blob.example.com")).validate())
  }
  
  func test_builder_either() {
   
    struct Sut: Validation {
      
      typealias Value = String
      
      let onlyBlobs: Bool
      
      var body: some Validation<String> {
        Validator {
          if onlyBlobs {
            Validator.equals("Blob")
          } else {
            Validators.NotEmpty()
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
   
    struct Sut: Validation {
      
      typealias Value = String
      
      let onlyBlobs: Bool
      
      var body: some Validation<String> {
        Validator {
          Validators.Success()
          if onlyBlobs {
            Validator.equals("Blob")
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
      
      var body: some Validation<Self> {
        Accumulating {
          Validate(\.name, using: Validators.NotEmpty())
          Validate(\.email) {
            String.notEmpty()
            String.contains("@")
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
      print(validationErrors)
      XCTAssertEqual(validationErrors.count, 2)
    }
  }
  
  func test_true_validator() {
    
    let isTrue = ValidatorOf<Bool> { true }
    
    XCTAssertNoThrow(try isTrue.validate(true))
    XCTAssertThrowsError(try isTrue.validate(false))
    
    struct User: Validatable {
      let name: String
      let email: String
      let isAdmin: Bool
      
      var body: some Validation<Self> {
        Accumulating {
          Validate(\.isAdmin, using: true)
        }
      }
    }
    
    XCTAssertNoThrow(try User(name: "Blob", email: "blob@example.com", isAdmin: true).validate())
    XCTAssertThrowsError(try User(name: "Blob", email: "blob@example.com", isAdmin: false).validate())
    
  }
  
  func test_false_validator() {
    
    let isFalse = ValidatorOf<Bool> { false }
    
    XCTAssertNoThrow(try isFalse.validate(false))
    XCTAssertThrowsError(try isFalse.validate(true))
    
    struct User: Validatable {
      let name: String
      let email: String
      let isAdmin: Bool
      
      var body: some Validation<Self> {
        Accumulating {
          Validate(\.isAdmin, using: false)
        }
      }
    }
    
    XCTAssertNoThrow(try User(name: "Blob", email: "blob@example.com", isAdmin: false).validate())
    XCTAssertThrowsError(try User(name: "Blob", email: "blob@example.com", isAdmin: true).validate())
    
  }
  
  func test_never_validator() {
    let validator = ValidatorOf<Int>.fail()
    XCTAssertThrowsError(try validator.validate(0))
  }
  
  func test_email() {
    let sut = ValidatorOf<String>.email()
    let sut2 = String.email(.international)
    
    XCTAssertNoThrow(try sut.validate("blob@example.com"))
    XCTAssertNoThrow(try sut2.validate("blob@example.com"))
    XCTAssertThrowsError(try sut.validate("blob@example@com"))
    XCTAssertThrowsError(try sut2.validate("blob@example@com"))
  }
  
  func test_mapError() {
    enum TestError: Error {
      case invalid
    }
    
    let sut = ValidatorOf<Int>
      .fail()
      .mapError(TestError.invalid)
    
    do {
      try sut.validate(1)
    } catch {
      let testError = error as! TestError
      XCTAssertEqual(testError, .invalid)
    }
  }
  
  func test_optional() throws {
    let nilValidator = ValidatorOf<Int?>.nil()
    
    XCTAssertNoThrow(try nilValidator.validate(.none))
    XCTAssertThrowsError(try nilValidator.validate(.some(1)))
    
    let sut = Int.greaterThan(10).optional()
    XCTAssertNoThrow(try sut.validate(.none))
    XCTAssertNoThrow(try sut.validate(11))
    XCTAssertThrowsError(try sut.validate(1))
    
    let sut2 = ValidatorOf<Int?>.nil().or {
      Int.greaterThan(10).optional()
    }
    
    XCTAssertNoThrow(try sut2.validate(.none))
    XCTAssertNoThrow(try sut2.validate(11))
    XCTAssertThrowsError(try sut2.validate(1))
    
    let sut3 = ValidatorOf<Int?>.notNil().map {
      Int.greaterThan(10)
    }
    XCTAssertNoThrow(try sut3.validate(.some(11)))
    XCTAssertThrowsError(try sut3.validate(.some(9)))
    XCTAssertThrowsError(try sut3.validate(.none))
    
    struct HoldsOptional {
      let count: Int?
    }
    
    let sut4 = ValidatorOf<HoldsOptional> {
      Validate(\.count) {
        Validators.NotNil()
        Int.greaterThan(10).optional()
      }
    }
    XCTAssertNoThrow(try sut4.validate(.init(count: 11)))
    XCTAssertThrowsError(try sut4.validate(.init(count: 9)))
    XCTAssertThrowsError(try sut4.validate(.init(count: .none)))
    
//    let sut5 = Int?.greaterThan(10)
//    XCTAssertNoThrow(try sut.validate(.none))
//    XCTAssertNoThrow(try sut.validate(11))
//    XCTAssertThrowsError(try sut.validate(1))
    
  }
  
}

extension Int {
  var zero: Int { 0 }
}

