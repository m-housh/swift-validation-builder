@testable import Validations
import XCTest

final class BuilderTests: XCTestCase {
 
  func test_validationBuilder_limitedAvailabilty() {
    let validator = Validation {
      if #available(macOS 10.15, *) {
        Validators.Always<Int>()
      } else {
        Validators.Always<Int>()
      }
    }
    
    XCTAssertNoThrow(try validator.validate(1))
  }
  
  func test_oneOfBuilder_buildEither() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validator<Self> {
        OneOf {
          if shouldAllowOnes {
            Validators.Always()
          } else {
            Validate(\.number) {
              Not(Equals(1))
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(shouldAllowOnes: true, number: 1).validate())
    XCTAssertThrowsError(try Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_oneOfBuilder_limitedAvailability() {
    let validator = Validation {
      OneOf {
        if #available(macOS 10.15, *) {
          Validators.Always<Int>()
        } else {
          Validators.Always<Int>()
        }
      }
    }
    
    XCTAssertNoThrow(try validator.validate(1))
  }
  
  func test_oneOfBuilder_buildOptional() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validator<Self> {
        OneOf {
          Validators.Never()
          if !shouldAllowOnes {
            Validate(\.number) {
              Not(Equals(1))
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
      
      var body: some Validator<Self> {
        Accumulating {
          if shouldAllowOnes {
            Validators.Always()
          } else {
            Validate(\.number) {
              Not(Equals(1))
            }
          }
        }
      }
    }
    
    XCTAssertNoThrow(try Sut(shouldAllowOnes: true, number: 1).validate())
    XCTAssertThrowsError(try Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_accumulatingBuilder_limitedAvailability() {
    let validator = Validation {
      Accumulating {
        if #available(macOS 10.15, *) {
          Validators.Always<Int>()
        } else {
          Validators.Always<Int>()
        }
      }
    }
    
    XCTAssertNoThrow(try validator.validate(1))
  }
  
  func test_accumulatingBuilder_buildOptional() {
    struct Sut: Validatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some Validator<Self> {
        Accumulating {
          Validators.Always()
          if !shouldAllowOnes {
            Validate(\.number) {
              Not(Equals(1))
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
      
      var body: some AsyncValidator<Self> {
        AsyncValidation {
          Validators.Always()
          if !shouldAllowOnes {
            Validate(\.number) {
              Not(Equals(1))
            }
          }
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(shouldAllowOnes: true, number: 1).validate())
    await XCTAssertThrowsAsyncError(try await Sut(shouldAllowOnes: false, number: 1).validate())
  }
  
  func test_asyncBuilder_limitedAvailability() async {
    let validator = AsyncValidation<Int> {
      if #available(macOS 10.15, *) {
        Validators.Always()
      } else {
        Validators.Always()
      }
    }
    
    await XCTAssertNoThrowAsync(try await validator.validate(1))
  }
  
  func test_asyncBuilder_buildEither() async {
    struct Sut: AsyncValidatable {
      let shouldAllowOnes: Bool
      let number: Int
      
      var body: some AsyncValidator<Self> {
        AsyncValidation {
          if shouldAllowOnes {
            Validators.Always()
          } else {
            Validate(\.number) {
              Not(Equals(1))
            }
          }
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(shouldAllowOnes: true, number: 1).validate())
    await XCTAssertThrowsAsyncError(try await Sut(shouldAllowOnes: false, number: 1).validate())
  }
}
