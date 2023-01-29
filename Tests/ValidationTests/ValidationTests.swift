import XCTest
@testable import Validations

struct User {
  var id: Int
  var name: String
  var email: String
}

extension Int {
  var zero: Int { 0 }
}

//extension Contains {
//
//  init<Parent>(_ lhs: KeyPath<Parent, Value>, _ rhs: KeyPath<Parent, Value.Element>) {
//    self.init({ $0[keyPath: lhs] }, { $0[keyPath: rhs] })
//  }
//}

final class ValidationTests: XCTestCase {
  
  func testSanity() {
    XCTAssert(true)
  }
  
  func test_or_validator() throws {
    let validators = [
      Validation {
        Always()
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
      XCTAssertNoThrow(try validator.validator.validate(11))
      XCTAssertNoThrow(try validator.validate(5))
      XCTAssertThrowsError(try validator.validate(4))
    }
    
    XCTAssertNoThrow(try validators.validator.validate(11))
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
      Validate(\.one) { parent in
        Contains(parent.two)
      }
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
        }
      }
    }
    
    XCTAssertThrowsError(try Sut(one: 13, two: 13).validate())
    XCTAssertThrowsError(try Sut(one: 3, two: 2).validate())
    XCTAssertNoThrow(try Sut(one: 10, two: 11).validate())
    
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
//    XCTAssertNoThrow(try Sut(one: 10, two: 11).validate())
  }
  
//  func test_validator() throws {
//    let validator = Validator {
//      EmptyValidator<Capacity.Cooling>()
//      Equals(\Capacity.Cooling.sensible, \.sensible)
//      Equals(\Capacity.Cooling.sensible, 10_000)
//      GreaterThan(\Capacity.Cooling.total, \.sensible)
//      GreaterThan(\Capacity.Cooling.total, 10)
//    }
//
//    try validator.validate(Capacity.Cooling.test)
//  }
//
//  func test_greaterThanValidator_fails() throws {
//
//    let validator = Validator {
//      GreaterThan(\Capacity.Cooling.total, 100_000)
//    }
//
//    XCTAssertThrowsError(try validator.validate(.test))
//
//  }
//
//  func test_not_validator_fails() throws {
//    let validator = Validator {
//      Not(Equals(\Capacity.Cooling.total, 12_000))
//    }
//    XCTAssertThrowsError(try validator.validate(.test))
//  }
//
//  func test_not_validator() throws {
//    let validator = Validator {
//      Not {
//        GreaterThan(\Capacity.Cooling.sensible, 11_000)
//      }
//    }
//
//    do {
//      try validator.validate(.test)
//    } catch {
//      XCTFail()
//    }
//
//  }
}

//extension Capacity.Cooling {
//  static let test = Self.init(total: 12_000, sensible: 10_000)
//}
