// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class GetUserPointsQuery: GraphQLQuery {
    static let operationName: String = "GetUserPoints"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetUserPoints($userId: ID!) { getUser(userId: $userId) { __typename points } }"#
      ))

    public var userId: ID

    public init(userId: ID) {
      self.userId = userId
    }

    public var __variables: Variables? { ["userId": userId] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getUser", GetUser?.self, arguments: ["userId": .variable("userId")]),
      ] }

      var getUser: GetUser? { __data["getUser"] }

      /// GetUser
      ///
      /// Parent Type: `User`
      struct GetUser: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("points", Int.self),
        ] }

        var points: Int { __data["points"] }
      }
    }
  }

}