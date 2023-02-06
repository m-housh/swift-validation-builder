import XCTest
import CasePaths
import CustomDump
@testable import Validations

final class AsyncValidationTests: XCTestCase {
  
  func test_or_validator() async {
    let validators = [
      AsyncValidator {
        AsyncValidator.success()
        Int.greaterThan(10).async().or(.equals(5))
      },
      AsyncValidator {
        Int.equals(5).async().or(.greaterThan(10))
      },
      AsyncValidator {
        Int.equals(5).async().or {
          Int.greaterThan(10)
        }
      }
    ]

    for validator in validators {
      await XCTAssertNoThrowAsync(try await validator.validate(11))
      await XCTAssertNoThrowAsync(try await validator.validate(5))
      await XCTAssertThrowsAsyncError(try await validator.validate(4))
    }

    await XCTAssertNoThrowAsync(try await validators.validator().validate(11))
  }
 
  func test_empty() async {
    let sut1 = String.empty().async()
    let sut2 = AsyncValidatorOf<String>.empty()
    
    await XCTAssertNoThrowAsync(try await sut1.validate(""))
    await XCTAssertNoThrowAsync(try await sut2.validate(""))
    await XCTAssertThrowsAsyncError(try await sut1.validate("foo"))
    await XCTAssertThrowsAsyncError(try await sut2.validate("foo"))
  }
  
  func test_notEmpty() async {
    let sut1 = String.notEmpty().async()
    let sut2 = AsyncValidatorOf<String>.notEmpty()
    
    await XCTAssertNoThrowAsync(try await sut1.validate("foo"))
    await XCTAssertNoThrowAsync(try await sut2.validate("foo"))
    await XCTAssertThrowsAsyncError(try await sut1.validate(""))
    await XCTAssertThrowsAsyncError(try await sut2.validate(""))
    
    struct Sut {
      let values: [Int]
    }
    
    let sutValidator = AsyncValidatorOf<Sut> {
      AsyncValidator.validate(\Sut.values, with: [Int].notEmpty().async())
    }
    
    await XCTAssertNoThrowAsync(try await sutValidator.validate(.init(values: [1, 2])))
    await XCTAssertThrowsAsyncError(try await sutValidator.validate(.init(values: [])))
  }
  
  func test_contains_validator() async {
    let sut1 = AsyncValidatorOf<String>.contains("@")
    let sut2: any AsyncValidation<String> = String.contains("@").async()
    
    await XCTAssertNoThrowAsync(try await sut1.validate("foo@bar.com"))
    await XCTAssertNoThrowAsync(try await sut2.validate("foo@bar.com"))
    await XCTAssertThrowsAsyncError(try await sut1.validate("foo.bar.com"))
    await XCTAssertThrowsAsyncError(try await sut2.validate("foo.bar.com"))
    
    struct Sut {
      let one: [String]
      let two: String
    }
    
    let sut = AsyncValidator<Sut> {
      AsyncValidator.contains(\.one, \.two)
    }

    await XCTAssertNoThrowAsync(
      try await sut.validate(.init(one: ["foo", "bar"], two: "foo"))
    )
    await XCTAssertThrowsAsyncError(try await sut.validate(.init(one: ["baz", "bar"], two: "foo")))
    
    let sut4 = AsyncValidator<Sut> {
      AsyncValidator.contains(\.one, element: "foo")
    }
    await XCTAssertNoThrowAsync(
      try await sut4.validate(.init(one: ["foo", "bar"], two: "foo"))
    )
    await XCTAssertThrowsAsyncError(try await sut4.validate(.init(one: ["baz", "bar"], two: "foo")))
    
  }
  
  func test_greater_than_validator() async {

    let validator = AsyncValidator {
      Int.greaterThan(10).async()
      Int.greaterThan(Int.zero).async()
    }
    
    await XCTAssertNoThrowAsync(try await validator.validate(11))
    await XCTAssertThrowsAsyncError(try await validator.validate(10))
    
    struct Sut {
      let one: Int
      let two: Int
    }
  
    let sut = AsyncValidatorOf<Sut> {
      AsyncValidator.validate(\.one) {
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        Int.greaterThan(10).async()
        AsyncValidator.not(.greaterThan(15))
      }
      AsyncValidator.validate(\.two, with: Int.lessThan(50).async())
      AsyncValidator.greaterThanOrEquals(20, \.two)
      AsyncValidator.greaterThan(20, \.two)
      AsyncValidator.greaterThan(\.one, \.two)
    }
    
    await XCTAssertNoThrowAsync(try await sut.validate(.init(one: 11, two: 10)))
    await XCTAssertThrowsAsyncError(try await sut.validate(.init(one: 16, two: 12)))
    await XCTAssertThrowsAsyncError(try await sut.validate(.init(one: 10, two: 9)))
    await XCTAssertThrowsAsyncError(try await sut.validate(.init(one: 11, two: 51)))
    
  }
  
  func test_lessThan() async {
      
    struct Sut: AsyncValidatable {
      let one: Int
      let two: Int
      
      var body: some AsyncValidation<Self> {
        AsyncValidator {
          AsyncValidator.lessThan(\.one, 12)
          AsyncValidator.lessThanOrEquals(\.one, \.two)
          AsyncValidator.lessThanOrEquals(0, \.two)
          AsyncValidator.lessThan(\.one, \.two)
          AsyncValidator.lessThan(1, \.two)
          AsyncValidator.validate(\.one, with: Int.lessThanOrEquals(13).async())
        }
      }
    }
    
    await XCTAssertThrowsAsyncError(try await Sut(one: 13, two: 13).validate())
    await XCTAssertThrowsAsyncError(try await Sut(one: 3, two: 2).validate())
    await XCTAssertNoThrowAsync(try await Sut(one: 10, two: 11).validate())
    
    let lessThanOrEqualsOne = AsyncValidatorOf<Int>.lessThan(1).or(.equals(1))
    let lessThanOrEqualsOne2 = AsyncValidatorOf<Int>.lessThanOrEquals(1)
    
    await XCTAssertThrowsAsyncError(try await lessThanOrEqualsOne.validate(2))
    await XCTAssertNoThrowAsync(try await lessThanOrEqualsOne.validate(1))
    await XCTAssertThrowsAsyncError(try await lessThanOrEqualsOne2.validate(2))
    await XCTAssertNoThrowAsync(try await lessThanOrEqualsOne2.validate(1))
    
    let lessThan12 = AsyncValidatorOf<Int>.lessThan(12)
    
    await XCTAssertThrowsAsyncError(try await lessThan12.validate(12))
    await XCTAssertNoThrowAsync(try await lessThan12.validate(11))
    
  }
  
  func test_greater_than_or_equals_validator() async {
    let validator = AsyncValidatorOf<Int>.greaterThanOrEquals(10)
    
    await XCTAssertNoThrowAsync(try await validator.validate(10))
    await XCTAssertThrowsAsyncError(try await validator.validate(9))
    
    struct Sut {
      let one: Int
      let two: Int
    }
  
    let sut = AsyncValidatorOf<Sut>.greaterThanOrEquals(\Sut.one, \.two)
    await XCTAssertNoThrowAsync(try await sut.validate(.init(one: 11, two: 10)))
    await XCTAssertNoThrowAsync(try await sut.validate(.init(one: 11, two: 11)))
    await XCTAssertThrowsAsyncError(try await sut.validate(.init(one: 10, two: 11)))
    
    let sut2 = AsyncValidatorOf<Sut>.greaterThanOrEquals(11, \Sut.two)
    await XCTAssertNoThrowAsync(try await sut2.validate(.init(one: 11, two: 10)))
    await XCTAssertNoThrowAsync(try await sut2.validate(.init(one: 11, two: 11)))
    await XCTAssertThrowsAsyncError(try await sut2.validate(.init(one: 10, two: 12)))

  }
  
  func test_not_validator() async {
    
    let validator = AsyncValidatorOf<Int>.not { AsyncValidator.greaterThan(0) }
    
    await XCTAssertThrowsAsyncError(try await validator.validate(4))
    await XCTAssertNoThrowAsync(try await validator.validate(-1))
  }
  
  func test_validatable() async {
    struct Sut: AsyncValidatable {
      let one: Int
      let two: Int
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.equals(\.one, \.two)
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(one: 1, two: 1).validate())
    await XCTAssertThrowsAsyncError(try await Sut(one: 1, two: 2).validate())
  }
  
  func test_case() async {
    enum Sut: Equatable {
      case one(Int)
      case two(Int)
      case three(Int)
    }

    let sut = AsyncValidator.oneOf {
      AsyncValidator.case(/Sut.one, with: .greaterThan(0))
      AsyncValidator.case(/Sut.two) {
        Int.greaterThan(10).async()
      }
    }

    await XCTAssertNoThrowAsync(try await sut.validate(.one(1)))
    await XCTAssertNoThrowAsync(try await sut.validate(.two(11)))
    await XCTAssertThrowsAsyncError(try await sut.validate(.three(0)))

  }
  
  func test_oneOF() async {
    let sut = AsyncValidator.oneOf {
      Int.greaterThan(0).async()
      AsyncValidator.equals(-10)
    }

    await XCTAssertThrowsAsyncError(try await sut.validate(-1))
    await XCTAssertNoThrowAsync(try await sut.validate(-10))
    await XCTAssertNoThrowAsync(try await sut.validate(1))

    let sut2 = AsyncValidatorOf<Int> {
      AsyncValidator.oneOf {
        AsyncValidator.greaterThan(0)
        AsyncValidator.equals(-10)
      }
    }
    await XCTAssertThrowsAsyncError(try await sut2.validate(-1))
    await XCTAssertNoThrowAsync(try await sut2.validate(-10))
    await XCTAssertNoThrowAsync(try await sut2.validate(1))
    
    let sut3 = AsyncValidatorOf<Int>.oneOf {
      Int.greaterThan(0).async()
      Int.equals(-10).async()
    }
    
    await XCTAssertThrowsAsyncError(try await sut3.validate(-1))
    await XCTAssertNoThrowAsync(try await sut3.validate(-10))
    await XCTAssertNoThrowAsync(try await sut3.validate(1))

  }
  
  func test_documenation() async {
    
    struct User: AsyncValidatable {
      
      let name: String
      let email: String
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.accumulating {
          AsyncValidator.validate(\.name, with: .notEmpty())
          AsyncValidator.validate(\.email, with: .accumulating {
            String.notEmpty().async()
            String.contains("@").async()
          })
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await User(name: "blob", email: "blob@example.com").validate())
    await XCTAssertThrowsAsyncError(try await User(name: "", email: "blob@example.com").validate())
    
    struct HoldsUser: AsyncValidatable {
      let user: User
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.validate(\.user)
      }
    }
    
    await XCTAssertNoThrowAsync(
      try await HoldsUser(user: .init(name: "blob", email: "blob@example.com")).validate()
    )
    await XCTAssertThrowsAsyncError(
      try await HoldsUser(user: .init(name: "blob", email: "blob.example.com")).validate()
    )
  }
  
  func test_builder_either() async {
   
    struct Sut: AsyncValidation {
      
      typealias Value = String
      
      let onlyBlobs: Bool
      
      var body: some AsyncValidation<String> {
        AsyncValidator {
          if onlyBlobs {
            AsyncValidator.equals("Blob")
          } else {
            AsyncValidator.notEmpty()
          }
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(onlyBlobs: false).validate("foo"))
    await XCTAssertThrowsAsyncError(try await Sut(onlyBlobs: false).validate(""))
    
    await XCTAssertNoThrowAsync(try await Sut(onlyBlobs: true).validate("Blob"))
    await XCTAssertThrowsAsyncError(try await Sut(onlyBlobs: true).validate("foo"))
    
  }
  
  func test_builder_if() async {
   
    struct Sut: AsyncValidation {
      
      typealias Value = String
      
      let onlyBlobs: Bool
      
      var body: some AsyncValidation<String> {
        AsyncValidator {
          AsyncValidator.success()
          if onlyBlobs {
            AsyncValidator.equals("Blob")
          }
        }
      }
    }
    
    await XCTAssertNoThrowAsync(try await Sut(onlyBlobs: false).validate("foo"))
    await XCTAssertNoThrowAsync(try await Sut(onlyBlobs: true).validate("Blob"))
    await XCTAssertThrowsAsyncError(try await Sut(onlyBlobs: true).validate("foo"))
    
  }
  
  func test_accumulating_errors() async {
    struct User: AsyncValidatable {
      let name: String
      let email: String
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.accumulating {
          AsyncValidator.validate(\.name, with: .notEmpty())
          AsyncValidator.validate(\.email) {
            String.notEmpty().async()
            String.contains("@").async()
          }
        }
      }
    }

    await XCTAssertNoThrowAsync(try await User(name: "blob", email: "blob@example.com").validate())
    do {
      try await User(name: "", email: "blob.example.com").validate()
    } catch {
      guard case let .manyFailed(validationErrors, _) = error as! ValidationError else {
        XCTFail()
        return
      }
      XCTAssertEqual(validationErrors.count, 2)
    }
  }
  
  func test_true_validator() async {
    
    let isTrue = AsyncValidatorOf<Bool> { true }
    
    await XCTAssertNoThrowAsync(try await isTrue.validate(true))
    await XCTAssertThrowsAsyncError(try await isTrue.validate(false))
    
    struct User: AsyncValidatable {
      let name: String
      let email: String
      let isAdmin: Bool
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.accumulating {
          AsyncValidator.validate(\.isAdmin, with: true.async())
        }
      }
    }
    
    await XCTAssertNoThrowAsync(
      try await User(name: "Blob", email: "blob@example.com", isAdmin: true).validate()
    )
    await XCTAssertThrowsAsyncError(
      try await User(name: "Blob", email: "blob@example.com", isAdmin: false).validate()
    )
    
  }
  
  func test_false_validator() async {
    
    let isFalse = AsyncValidatorOf<Bool> { false }
    
    await XCTAssertNoThrowAsync(try await isFalse.validate(false))
    await XCTAssertThrowsAsyncError(try await isFalse.validate(true))
    
    struct User: AsyncValidatable {
      let name: String
      let email: String
      let isAdmin: Bool
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.accumulating {
          AsyncValidator.validate(\.isAdmin, with: false.async())
        }
      }
    }
    
    await XCTAssertNoThrowAsync(
      try await User(name: "Blob", email: "blob@example.com", isAdmin: false).validate()
    )
    await XCTAssertThrowsAsyncError(
      try await User(name: "Blob", email: "blob@example.com", isAdmin: true).validate()
    )
    
  }
  
  func test_fail_validator() async {
    let validator = AsyncValidatorOf<Int>.fail()
    await XCTAssertThrowsAsyncError(try await validator.validate(0))
  }
  
  func test_email() async {
    let sut = AsyncValidatorOf<String>.email()
    let sut2 = AsyncValidatorOf<String> { String.email(.international).async() }
    
    await XCTAssertNoThrowAsync(try await sut.validate("blob@example.com"))
    await XCTAssertNoThrowAsync(try await sut2.validate("blob@example.com"))
    await XCTAssertThrowsAsyncError(try await sut.validate("blob@example@com"))
    await XCTAssertThrowsAsyncError(try await sut2.validate("blob@example@com"))
  }
  
  func test_mapError() async {
    enum TestError: Error {
      case invalid
    }
    
    let sut = AsyncValidatorOf<Int>
      .fail()
      .mapError(TestError.invalid)
    
    do {
      try await sut.validate(1)
    } catch {
      let testError = error as! TestError
      XCTAssertEqual(testError, .invalid)
    }
    
     let sut2 = AsyncValidatorOf<Int>
      .fail()
      .mapError { error in
        XCTAssertNotNil(error as? ValidationError)
        throw TestError.invalid
      }
    
    do {
      try await sut2.validate(1)
    } catch {
      let testError = error as! TestError
      XCTAssertEqual(testError, .invalid)
    }

  }
  
  func test_optional() async {
    let nilValidator = AsyncValidatorOf<Int?>.nil()
    
    await XCTAssertNoThrowAsync(try await nilValidator.validate(.none))
    await XCTAssertThrowsAsyncError(try await nilValidator.validate(.some(1)))
    
    let sut = Int.greaterThan(10).async().optional()
    await XCTAssertNoThrowAsync(try await sut.validate(.none))
    await XCTAssertNoThrowAsync(try await sut.validate(11))
    await XCTAssertThrowsAsyncError(try await sut.validate(1))
    
    let sut2 = AsyncValidatorOf<Int?>.nil().or {
      Int.greaterThan(10).async().optional()
    }
    
    await XCTAssertNoThrowAsync(try await sut2.validate(.none))
    await XCTAssertNoThrowAsync(try await sut2.validate(11))
    await XCTAssertThrowsAsyncError(try await sut2.validate(1))
    
    let sut3 = AsyncValidatorOf<Int?>.notNil().map {
      Int.greaterThan(10).async()
    }
    await XCTAssertNoThrowAsync(try await sut3.validate(.some(11)))
    await XCTAssertThrowsAsyncError(try await sut3.validate(.some(9)))
    await XCTAssertThrowsAsyncError(try await sut3.validate(.none))
    
    struct HoldsOptional {
      let count: Int?
    }
    
    let sut4 = AsyncValidatorOf<HoldsOptional> {
      AsyncValidator.validate(\.count) { // fix validate to be async
        AsyncValidator.notNil()
        Int.greaterThan(10).optional().async()
      }
    }
    await XCTAssertNoThrowAsync(try await sut4.validate(.init(count: 11)))
    await XCTAssertThrowsAsyncError(try await sut4.validate(.init(count: 9)))
    await XCTAssertThrowsAsyncError(try await sut4.validate(.init(count: .none)))
  }
  
  func test_async_array() async {
    let validators = [
      Int.greaterThan(0).async(),
      Int.lessThan(20).async()
    ]
    
    let sut1 = validators.validator()
    await XCTAssertNoThrowAsync(try await sut1.validate(1))
    await XCTAssertThrowsAsyncError(try await sut1.validate(21))
    
    let sut2 = validators.validator(type: .oneOf)
    await XCTAssertNoThrowAsync(try await sut2.validate(1))
    await XCTAssertNoThrowAsync(try await sut2.validate(21))
    await XCTAssertThrowsAsyncError(try await sut2.validate(-2))
    
    let sut3 = [
      String.notEmpty().async().eraseToAnyAsyncValidator(),
      String.email().async().eraseToAnyAsyncValidator()
    ].validator(type: .accumulating)
    
    await XCTAssertNoThrowAsync(try await sut3.validate("blob@example.com"))
    do {
      try await sut3.validate("")
    } catch {
      let error = error as! ValidationError
      print(error)
      guard case let .manyFailed(errors, _) = error else {
        XCTFail()
        return
      }
      XCTAssertEqual(errors.count, 2)
      
    }
    
  }
  
  func test_any_async_validator() async {
    let sut = AnyAsyncValidator<String> { _ in
      throw ValidationError.failed(summary: "Always fails")
    }
    
    await XCTAssertThrowsAsyncError(try await sut.eraseToAnyAsyncValidator().validate(""))
  }
  
  func test_map_async() async {
    
    let sut = Int.greaterThan(1).async()
      .map {
        "\($0)" // convert the int to a string.
      } validation: {
        String.equals("2").async() // validate the string.
      }
    
    await XCTAssertNoThrowAsync(try await sut.validate(2))
    await XCTAssertThrowsAsyncError(try await sut.validate(3))
    
    let sut2 = Int.greaterThan(1).async()
      .map { _ in
        AnyAsyncValidator<Int> { int in
          guard int == 2 else {
            throw ValidationError.failed(summary: "Expected 2.")
          }
        }
      }
    
    await XCTAssertNoThrowAsync(try await sut2.validate(2))
    await XCTAssertThrowsAsyncError(try await sut2.validate(3))
    
    let sut3 = Int.greaterThan(1).async().map { Int.equals(2).async() }
    await XCTAssertNoThrowAsync(try await sut3.validate(2))
    await XCTAssertThrowsAsyncError(try await sut3.validate(3))
    
  }
  
  func test_map_value() async {
    
  }
  
  // TODO: Inline not working as expected in async contexts.
  func test_error_label() async {
    struct User: AsyncValidatable {
      let name: String
      let email: String
      let foo: String
      
      var body: some AsyncValidation<Self> {
        AsyncValidator.accumulating {
          AsyncValidator.validate(\.name) {
            AsyncValidator.accumulating {
                String.notEmpty().async()
                AsyncValidator.validate(\.count, with: .greaterThan(5))
                  .errorLabel("Name.count", inline: true)
              }
            }
              .errorLabel("Name")
          
          AsyncValidator.validate(\.email, with: .email())
            .errorLabel("Email")
          
          AsyncValidator.validate(\.foo, with: .notEmpty())
        }
      }
    }
    do {
      try await User(name: "", email: "", foo: "").validate()
    } catch {
      let error = error as! ValidationError
      let expected = """
       Expected to not be empty.
       Name:
       Expected to not be empty.
       Name.count:
       0 is not greater than 5
       
       Email:
       Expected to not be empty.
       
       """
      print(error.debugDescription)
      XCTAssertNoDifference(error.debugDescription, expected)
    }
  }
  
  func test_eraseToAnyValidator() async {
    let validator = Int.greaterThan(1).async().eraseToAnyAsyncValidator()
    await XCTAssertNoThrowAsync(try await validator.validate(2))
    await XCTAssertThrowsAsyncError(try await validator.validate(1))
  }
  
  func test_lazy_validator() async {
     func contains<V, C: Collection>(
      _ toCollection: KeyPath<V, C>,
      _ toElement: KeyPath<V, C.Element>
     ) -> AsyncValidator<V> where C.Element: Equatable {
      .init(
        AsyncValidator<V>.lazy { parent in
          AsyncValidator.validate(toCollection) {
            C.contains(parent[keyPath: toElement])
           }
         }
       )
     }
    
    struct Sut {
      let left: [String]
      let right: String
    }

    let sut = contains(\Sut.left, \.right)
   
    await XCTAssertNoThrowAsync(try await sut.validate(.init(left: ["foo", "bar"], right: "bar")))
    await XCTAssertThrowsAsyncError(try await sut.validate(.init(left: ["foo", "bar"], right: "blob")))
  }
}

