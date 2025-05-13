// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class RegisterUserMutation: GraphQLMutation {
    static let operationName: String = "RegisterUser"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation RegisterUser($registerInput: RegisterInput) { register(registerInput: $registerInput) { __typename username points major lastName id graduating firstName } }"#
      ))

    public var registerInput: GraphQLNullable<RegisterInput>

    public init(registerInput: GraphQLNullable<RegisterInput>) {
      self.registerInput = registerInput
    }

    public var __variables: Variables? { ["registerInput": registerInput] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("register", Register.self, arguments: ["registerInput": .variable("registerInput")]),
      ] }

      var register: Register { __data["register"] }

      /// Register
      ///
      /// Parent Type: `User`
      struct Register: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("username", String.self),
          .field("points", Int.self),
          .field("major", String.self),
          .field("lastName", String.self),
          .field("id", SHPESchema.ID.self),
          .field("graduating", String.self),
          .field("firstName", String.self),
        ] }

        var username: String { __data["username"] }
        var points: Int { __data["points"] }
        var major: String { __data["major"] }
        var lastName: String { __data["lastName"] }
        var id: SHPESchema.ID { __data["id"] }
        var graduating: String { __data["graduating"] }
        var firstName: String { __data["firstName"] }
      }
    }
  }

}