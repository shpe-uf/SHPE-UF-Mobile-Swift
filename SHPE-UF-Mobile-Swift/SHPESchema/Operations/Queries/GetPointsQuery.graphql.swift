// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class GetPointsQuery: GraphQLQuery {
    static let operationName: String = "GetPoints"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetPoints($userId: ID!) { getUser(userId: $userId) { __typename fallPoints springPoints summerPoints } }"#
      ))

    public var userId: ID

    public init(userId: ID) {
      self.userId = userId
    }

    public var __variables: Variables? { ["userId": userId] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
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

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("fallPoints", Int.self),
          .field("springPoints", Int.self),
          .field("summerPoints", Int.self),
        ] }

        var fallPoints: Int { __data["fallPoints"] }
        var springPoints: Int { __data["springPoints"] }
        var summerPoints: Int { __data["summerPoints"] }
      }
    }
  }

}