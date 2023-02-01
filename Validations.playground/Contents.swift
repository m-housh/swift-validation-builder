//import Validations
import Foundation

var greeting = "Hello, playground"

struct User {
  let name: String
  let email: String
}

let email = "blob@example.com"

let regexPatternString = """
(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}\
~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\\
x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-\
z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5\
]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-\
9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\
-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])
"""

func match(_ pattern: String, input: String) -> Bool {
  guard let range = input.range(of: pattern, options: [.regularExpression]) else {
    return false
  }
  return range.lowerBound == input.startIndex
  && range.upperBound == input.endIndex
}

match(regexPatternString, input: email)

//if #available(macOS 13.0, *) {
//  let regex = try Regex(regexPatternString)
//  let match = try regex.wholeMatch(in: email)
//  print("\(String(describing: match))")
//  print(match?.range ?? [0...1000])
//} else {
//  print("Oops")
//  // Fallback on earlier versions
//}

//@resultBuilder
//struct Foo {
//  let type: Int
//  
//  static func buildExpression(_ expression: String) -> String {
//    
//  }
//}
