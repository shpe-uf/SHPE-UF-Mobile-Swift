// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class SignInMutation: GraphQLMutation {
    static let operationName: String = "SignIn"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation SignIn($username: String!, $password: String!, $remember: String!) { login(username: $username, password: $password, remember: $remember) { __typename year username updatedAt confirmed createdAt email events { __typename attendance id name semester points } id firstName lastName major photo token country ethnicity graduating internships classes sex socialMedia permission } }"#
      ))

    public var username: String
    public var password: String
    public var remember: String

    public init(
      username: String,
      password: String,
      remember: String
    ) {
      self.username = username
      self.password = password
      self.remember = remember
    }

    public var __variables: Variables? { [
      "username": username,
      "password": password,
      "remember": remember
    ] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("login", Login.self, arguments: [
          "username": .variable("username"),
          "password": .variable("password"),
          "remember": .variable("remember")
        ]),
      ] }

      var login: Login { __data["login"] }

      /// Login
      ///
      /// Parent Type: `User`
      struct Login: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("year", String.self),
          .field("username", String.self),
          .field("updatedAt", String.self),
          .field("confirmed", Bool.self),
          .field("createdAt", String.self),
          .field("email", String.self),
          .field("events", [Event?].self),
          .field("id", SHPESchema.ID.self),
          .field("firstName", String.self),
          .field("lastName", String.self),
          .field("major", String.self),
          .field("photo", String.self),
          .field("token", String.self),
          .field("country", String.self),
          .field("ethnicity", String.self),
          .field("graduating", String.self),
          .field("internships", [String?]?.self),
          .field("classes", [String?]?.self),
          .field("sex", String.self),
          .field("socialMedia", [String?]?.self),
          .field("permission", String.self),
        ] }

        var year: String { __data["year"] }
        var username: String { __data["username"] }
        var updatedAt: String { __data["updatedAt"] }
        var confirmed: Bool { __data["confirmed"] }
        var createdAt: String { __data["createdAt"] }
        var email: String { __data["email"] }
        var events: [Event?] { __data["events"] }
        var id: SHPESchema.ID { __data["id"] }
        var firstName: String { __data["firstName"] }
        var lastName: String { __data["lastName"] }
        var major: String { __data["major"] }
        var photo: String { __data["photo"] }
        var token: String { __data["token"] }
        var country: String { __data["country"] }
        var ethnicity: String { __data["ethnicity"] }
        var graduating: String { __data["graduating"] }
        var internships: [String?]? { __data["internships"] }
        var classes: [String?]? { __data["classes"] }
        var sex: String { __data["sex"] }
        var socialMedia: [String?]? { __data["socialMedia"] }
        var permission: String { __data["permission"] }

        /// Login.Event
        ///
        /// Parent Type: `Event`
        struct Event: SHPESchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Event }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("attendance", Int.self),
            .field("id", SHPESchema.ID.self),
            .field("name", String.self),
            .field("semester", String.self),
            .field("points", Int.self),
          ] }

          var attendance: Int { __data["attendance"] }
          var id: SHPESchema.ID { __data["id"] }
          var name: String { __data["name"] }
          var semester: String { __data["semester"] }
          var points: Int { __data["points"] }
        }
      }
    }
  }

}