// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension SHPESchema {
  struct RedeemPointsInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      code: String,
      username: String,
      guests: Int
    ) {
      __data = InputDict([
        "code": code,
        "username": username,
        "guests": guests
      ])
    }

    var code: String {
      get { __data["code"] }
      set { __data["code"] = newValue }
    }

    var username: String {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    var guests: Int {
      get { __data["guests"] }
      set { __data["guests"] = newValue }
    }
  }

}