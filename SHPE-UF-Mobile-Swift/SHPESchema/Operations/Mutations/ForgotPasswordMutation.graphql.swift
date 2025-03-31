// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class ForgotPasswordMutation: GraphQLMutation {
    static let operationName: String = "ForgotPassword"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation ForgotPassword($email: String!) { forgotPassword(email: $email) { __typename id token } }"#
      ))

    public var email: String

    public init(email: String) {
      self.email = email
    }

    public var __variables: Variables? { ["email": email] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("forgotPassword", ForgotPassword.self, arguments: ["email": .variable("email")]),
      ] }

      var forgotPassword: ForgotPassword { __data["forgotPassword"] }

      /// ForgotPassword
      ///
      /// Parent Type: `User`
      struct ForgotPassword: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", SHPESchema.ID.self),
          .field("token", String.self),
        ] }

        var id: SHPESchema.ID { __data["id"] }
        var token: String { __data["token"] }
      }
    }
  }

}