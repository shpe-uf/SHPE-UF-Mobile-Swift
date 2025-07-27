// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension SHPESchema {
  struct CreateEventInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      name: String,
      code: String,
      category: String,
      points: String,
      expiration: String,
      request: String
    ) {
      __data = InputDict([
        "name": name,
        "code": code,
        "category": category,
        "points": points,
        "expiration": expiration,
        "request": request
      ])
    }

    var name: String {
      get { __data["name"] }
      set { __data["name"] = newValue }
    }

    var code: String {
      get { __data["code"] }
      set { __data["code"] = newValue }
    }

    var category: String {
      get { __data["category"] }
      set { __data["category"] = newValue }
    }

    var points: String {
      get { __data["points"] }
      set { __data["points"] = newValue }
    }

    var expiration: String {
      get { __data["expiration"] }
      set { __data["expiration"] = newValue }
    }

    var request: String {
      get { __data["request"] }
      set { __data["request"] = newValue }
    }
  }

}