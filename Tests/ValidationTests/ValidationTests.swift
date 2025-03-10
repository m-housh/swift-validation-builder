import CasePaths
import CustomDump
@testable import Validations
import XCTest

final class ValidationTests: XCTestCase {

  func testSanity() {
    XCTAssert(true)
  }

  func test_or_validator() throws {
    let validators = [
      Validator<Int> {
        Validator.success()
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
      Validator.validate(\Sut.values, with: [Int].notEmpty())
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

    let sut4 = Validator<Sut> { Validator.contains(\.one, element: "foo") }
    XCTAssertNoThrow(
      try sut4.validate(.init(one: ["foo", "bar"], two: "foo"))
    )
    XCTAssertThrowsError(try sut4.validate(.init(one: ["baz", "bar"], two: "foo")))
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
      Validator.greaterThan(\.one, \.two)
      Validator.validate(\.one) {
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Int.greaterThan(10)
        Validator.not(.greaterThan(15))
      }
      Validator.validate(\.two, with: Int.lessThan(50))
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
          Validator.lessThan(\.one, \.two)
          Validator.lessThan(1, \.two)
          Validator.validate(\.one, with: Int.lessThanOrEquals(13))
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

    let lessThanOrEquals12 = ValidatorOf<Int>.lessThanOrEquals(12)
    XCTAssertNoThrow(try lessThanOrEquals12.validate(12))
    XCTAssertThrowsError(try lessThanOrEquals12.validate(13))
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

    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 10)))
    XCTAssertNoThrow(try sut.validate(.init(one: 11, two: 11)))
    XCTAssertThrowsError(try sut.validate(.init(one: 10, two: 11)))

    let sut2 = ValidatorOf<Sut>.greaterThanOrEquals(11, \.two)
    XCTAssertNoThrow(try sut2.validate(.init(one: 11, two: 10)))
    XCTAssertNoThrow(try sut2.validate(.init(one: 11, two: 11)))
    XCTAssertThrowsError(try sut2.validate(.init(one: 10, two: 12)))
  }

  func test_not_validator() throws {
    let validator = ValidatorOf<Int>.not { Validator.greaterThan(0) }
    XCTAssertThrowsError(try validator.validate(4))
    XCTAssertNoThrow(try validator.validate(-1))

    let greaterThanZero: some Validation<Int> = Int.greaterThan(0)
    let sut = ValidatorOf<Int>.not(greaterThanZero)

    XCTAssertThrowsError(try sut.validate(4))
    XCTAssertNoThrow(try sut.validate(-1))
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

  func test_case() throws {
    let sut = Validator<Sut>.oneOf {
      Validator.case(\.one, with: Int.greaterThan(0))
      Validator.case(\.two, with: Int.greaterThan(10))
    }

    XCTAssertNoThrow(try sut.validate(Sut.one(1)))
    XCTAssertNoThrow(try sut.validate(Sut.two(11)))
    XCTAssertThrowsError(try sut.validate(Sut.three(0)))
  }

  func test_oneOF() throws {
    let sut = Validator.oneOf {
      Int.greaterThan(0)
      Validator.equals(-10)
    }

    XCTAssertThrowsError(try sut.validate(-1))
    XCTAssertNoThrow(try sut.validate(-10))
    XCTAssertNoThrow(try sut.validate(1))

    let sut2 = ValidatorOf<Int> {
      Validator.oneOf {
        Validator.greaterThan(0)
        Validator.equals(-10)
      }
    }
    XCTAssertThrowsError(try sut2.validate(-1))
    XCTAssertNoThrow(try sut2.validate(-10))
    XCTAssertNoThrow(try sut2.validate(1))

    let sut3 = ValidatorOf<Int>.oneOf {
      Int.greaterThan(0)
      Int.equals(-10)
    }

    XCTAssertThrowsError(try sut3.validate(-1))
    XCTAssertNoThrow(try sut3.validate(-10))
    XCTAssertNoThrow(try sut3.validate(1))
  }

  func test_documenation() {
    struct User: Validatable {

      let name: String
      let email: String

      var body: some Validation<Self> {
        Validator.accumulating {
          Validator.validate(\.name, with: .notEmpty())
          Validator.validate(\.email, with: .accumulating {
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
        Validator.validate(\.user)
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
            Validator.notEmpty()
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
          Validator.success()
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
        Validator.accumulating {
          Validator.validate(\.name, with: .notEmpty())
          Validator.validate(\.email) {
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
        Validator.accumulating {
          Validator.validate(\.isAdmin, with: true)
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
        Validator.accumulating {
          Validator.validate(\.isAdmin, with: false)
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
    let sut2 = ValidatorOf<String> { String.email(.international) }

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

    let sut2 = ValidatorOf<Int>
      .fail()
      .mapError { error in
        XCTAssertNotNil(error as? ValidationError)
        throw TestError.invalid
      }

    do {
      try sut2.validate(1)
    } catch {
      let testError = error as! TestError
      XCTAssertEqual(testError, .invalid)
    }
  }

  func test_optional() throws {
    let nilValidator = ValidatorOf<Int?>.nil()

    XCTAssertNoThrow(try nilValidator.validate(.none))
    XCTAssertThrowsError(try nilValidator.validate(.some(1)))

    let sut: some Validation<Int?> = Int.greaterThan(10).optional()
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
      Validator.validate(\HoldsOptional.count) {
        Validator.notNil()
        Int.greaterThan(10).optional()
      }
    }
    XCTAssertNoThrow(try sut4.validate(.init(count: 11)))
    XCTAssertThrowsError(try sut4.validate(.init(count: 9)))
    XCTAssertThrowsError(try sut4.validate(.init(count: .none)))
  }

  func test_any_validator() {
    let sut = AnyValidator<String> { _ in
      throw ValidationError.failed(summary: "Always fails")
    }

    XCTAssertThrowsError(try sut.eraseToAnyValidator().validate(""))
  }

  func test_map() {
    let sut = Int.greaterThan(1)
      .map(to: Validator<String>.self) {
        "\($0)" // convert the int to a string.
      } validation: {
        String.equals("2") // validate the string.
      }

    XCTAssertNoThrow(try sut.validate(2))
    XCTAssertThrowsError(try sut.validate(3))

    let sut2 = Int.greaterThan(1)
      .map { _ in
        AnyValidator<Int> { int in
          guard int == 2 else {
            throw ValidationError.failed(summary: "Expected 2.")
          }
        }
      }

    XCTAssertNoThrow(try sut2.validate(2))
    XCTAssertThrowsError(try sut2.validate(3))

    // let sut3 = Int.greaterThan(1).map<Int> { Int.equals(2) }
    // XCTAssertNoThrow(try sut3.validate(2))
    // XCTAssertThrowsError(try sut3.validate(3))
  }

  func test_error_label() throws {
    struct User: Validatable {
      let name: String
      let email: String
      let foo: String

      enum Labels: String, CustomStringConvertible {
        case name
        case email
        case count

        var description: String {
          switch self {
          case .name, .email:
            return rawValue.capitalized
          case .count:
            return "Name.count"
          }
        }
      }

      var body: some Validation<Self> {
        Validator.accumulating {
          Validator.validate(\.name) {
            Validator.accumulating {
              String.notEmpty()
              Validator.validate(\.count, with: .greaterThan(5))
                .errorLabel(Labels.count, inline: true)
            }
          }
          .errorLabel(Labels.name)

          Validator.validate(\.email, with: .email())
            .errorLabel(Labels.email)

          Validator.validate(\.foo, with: .notEmpty())
        }
      }
    }
    do {
      try User(name: "", email: "", foo: "").validate()
    } catch {
      let error = error as! ValidationError
      let expected = """
      Expected to not be empty.
      Name:
      Expected to not be empty.
      Name.count: 0 is not greater than 5

      Email:
      Expected to not be empty.

      """
      expectNoDifference(error.debugDescription, expected)
    }
  }

  func test_eraseToAnyValidator() {
    let validator = Int.greaterThan(1).eraseToAnyValidator()
    XCTAssertNoThrow(try validator.validate(2))
    XCTAssertThrowsError(try validator.validate(1))
  }
}

extension Int {
  var zero: Int { 0 }
}

@CasePathable
@dynamicMemberLookup
enum Sut: Equatable {
  case one(Int)
  case two(Int)
  case three(Int)
}
