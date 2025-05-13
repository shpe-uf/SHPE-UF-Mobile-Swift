// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension SHPESchema {
  struct RegisterInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      firstName: String,
      lastName: String,
      major: String,
      year: String,
      graduating: String,
      country: String,
      ethnicity: String,
      sex: String,
      username: String,
      email: String,
      password: String,
      confirmPassword: String,
      listServ: String
    ) {
      __data = InputDict([
        "firstName": firstName,
        "lastName": lastName,
        "major": major,
        "year": year,
        "graduating": graduating,
        "country": country,
        "ethnicity": ethnicity,
        "sex": sex,
        "username": username,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "listServ": listServ
      ])
    }

    var firstName: String {
      get { __data["firstName"] }
      set { __data["firstName"] = newValue }
    }

    var lastName: String {
      get { __data["lastName"] }
      set { __data["lastName"] = newValue }
    }

    var major: String {
      get { __data["major"] }
      set { __data["major"] = newValue }
    }

    var year: String {
      get { __data["year"] }
      set { __data["year"] = newValue }
    }

    var graduating: String {
      get { __data["graduating"] }
      set { __data["graduating"] = newValue }
    }

    var country: String {
      get { __data["country"] }
      set { __data["country"] = newValue }
    }

    var ethnicity: String {
      get { __data["ethnicity"] }
      set { __data["ethnicity"] = newValue }
    }

    var sex: String {
      get { __data["sex"] }
      set { __data["sex"] = newValue }
    }

    var username: String {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    var email: String {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    var password: String {
      get { __data["password"] }
      set { __data["password"] = newValue }
    }

    var confirmPassword: String {
      get { __data["confirmPassword"] }
      set { __data["confirmPassword"] = newValue }
    }

    var listServ: String {
      get { __data["listServ"] }
      set { __data["listServ"] = newValue }
    }
  }

}