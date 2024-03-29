// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension SHPESchema {
  struct EditUserProfileInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      email: String,
      firstName: String,
      lastName: String,
      photo: String,
      major: String,
      year: String,
      graduating: String,
      country: String,
      ethnicity: String,
      sex: String,
      classes: GraphQLNullable<[String?]> = nil,
      internships: GraphQLNullable<[String?]> = nil,
      socialMedia: GraphQLNullable<[String?]> = nil
    ) {
      __data = InputDict([
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "photo": photo,
        "major": major,
        "year": year,
        "graduating": graduating,
        "country": country,
        "ethnicity": ethnicity,
        "sex": sex,
        "classes": classes,
        "internships": internships,
        "socialMedia": socialMedia
      ])
    }

    var email: String {
      get { __data["email"] }
      set { __data["email"] = newValue }
    }

    var firstName: String {
      get { __data["firstName"] }
      set { __data["firstName"] = newValue }
    }

    var lastName: String {
      get { __data["lastName"] }
      set { __data["lastName"] = newValue }
    }

    var photo: String {
      get { __data["photo"] }
      set { __data["photo"] = newValue }
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

    var classes: GraphQLNullable<[String?]> {
      get { __data["classes"] }
      set { __data["classes"] = newValue }
    }

    var internships: GraphQLNullable<[String?]> {
      get { __data["internships"] }
      set { __data["internships"] = newValue }
    }

    var socialMedia: GraphQLNullable<[String?]> {
      get { __data["socialMedia"] }
      set { __data["socialMedia"] = newValue }
    }
  }

}