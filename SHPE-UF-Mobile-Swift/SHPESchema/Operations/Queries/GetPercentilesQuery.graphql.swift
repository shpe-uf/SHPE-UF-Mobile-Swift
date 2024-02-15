// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class GetPercentilesQuery: GraphQLQuery {
    static let operationName: String = "GetPercentiles"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetPercentiles($userId: ID!) { getUser(userId: $userId) { __typename fallPercentile springPercentile summerPercentile } }"#
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
          .field("fallPercentile", Int.self),
          .field("springPercentile", Int.self),
          .field("summerPercentile", Int.self),
        ] }

        var fallPercentile: Int { __data["fallPercentile"] }
        var springPercentile: Int { __data["springPercentile"] }
        var summerPercentile: Int { __data["summerPercentile"] }
      }
    }
  }

}