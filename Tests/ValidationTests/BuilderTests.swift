@testable import Validations
import XCTest

final class BuilderTests: XCTestCase {
 
  func test_validationBuilder_limitedAvailabilty() {
    let validator = ValidatorOf<Int> {
      if #available(macOS 10.15, *) {
        Validator.success()
      } else {
        Validator.success()
      }
    }
    
    XCTAssertNoThrow(try validator.validate(1))
  }
  
  func test_oneOfBuilder_buildEither() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validation<Self> {
        Validator.oneOf {
          if shouldAllowOnes {
            Validator.success()
          } else {
            Validator.validate(\.number) {
              Validator.not(.equals(1))
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(shouldAllowOnes: true, number: 1).validate())
    XCTAssertThrowsError(try Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_oneOfBuilder_limitedAvailability() {
    let validator = ValidatorOf<Int> {
      Validator.oneOf {
        if #available(macOS 10.15, *) {
          Validator.success()
        } else {
          Validator.success()
        }
      }
    }
    
    XCTAssertNoThrow(try validator.validate(1))
  }
  
  func test_oneOfBuilder_buildOptional() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validation<Self> {
        Validator.oneOf {
          Validator.fail()
          if !shouldAllowOnes {
            Validator.validate(\.number) {
              Validator.not(.equals(1))
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(shouldAllowOnes: true, number: 1).validate())
    XCTAssertThrowsError(try Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_accumulatingBuilder_buildEither() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validation<Self> {
        Validator.accumulating {
          if shouldAllowOnes {
            Validator.success()
          } else {
            Validator.validate(\.number) {
              Validator.not(.equals(1))
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(shouldAllowOnes: true, number: 1).validate())
    XCTAssertThrowsError(try Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_accumulatingBuilder_limitedAvailability() {
    let validator = ValidatorOf<Int> {
      Validator.accumulating {
        if #available(macOS 10.15, *) {
          Validator.success()
        } else {
          Validator.success()
        }
      }
    }
    
    XCTAssertNoThrow(try validator.validate(1))
  }
  
  func test_accumulatingBuilder_buildOptional() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validation<Self> {
        Validator.accumulating {
          Validator.success()
          if !shouldAllowOnes {
            Validator.validate(\.number) {
              Validator.not(.equals(1))
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(shouldAllowOnes: true, number: 1).validate())
    XCTAssertThrowsError(try Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_asyncBuilder_buildOptional() async {
    struct Sut: AsyncValidatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some AsyncValidation<Self> {
        AsyncValidator {
          Validator.success()
          if !shouldAllowOnes {
            AsyncValidator.validate(\.number) {
              Validator.not(.equals(1))
            }
          }
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(shouldAllowOnes: true, number: 1).validate())
    await XCTAssertThrowsAsyncError(try await Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_asyncBuilder_limitedAvailability() async {
    let validator = AsyncValidator<Int> {
      if #available(macOS 10.15, *) {
        Validator.success()
      } else {
        Validator.success()
      }
    }
    
    await XCTAssertNoThrowAsync(try await validator.validate(1))
  }
  
  func test_asyncBuilder_buildEither() async {
    struct Sut: AsyncValidatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some AsyncValidation<Self> {
        AsyncValidator {
          if shouldAllowOnes {
            Validator.success()
          } else {
            AsyncValidator.validate(\.number) {
              Validator.not(.equals(1))
            }
          }
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(shouldAllowOnes: true, number: 1).validate())
    await XCTAssertThrowsAsyncError(try await Sut(shouldAllowOnes: false, number: 1).validate())
  }
}
