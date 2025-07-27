// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class DeleteUserMutation: GraphQLMutation {
    static let operationName: String = "DeleteUser"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation DeleteUser($email: String!) { deleteUser(email: $email) }"#
      ))

    public var email: String

    public init(email: String) {
      self.email = email
    }

    public var __variables: Variables? { ["email": email] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("deleteUser", Bool?.self, arguments: ["email": .variable("email")]),
      ] }

      var deleteUser: Bool? { __data["deleteUser"] }
    }
  }

}