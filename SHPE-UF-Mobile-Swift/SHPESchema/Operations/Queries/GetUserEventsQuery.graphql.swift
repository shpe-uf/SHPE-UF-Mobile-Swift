// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class GetUserEventsQuery: GraphQLQuery {
    static let operationName: String = "GetUserEvents"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetUserEvents($userId: ID!) { getUser(userId: $userId) { __typename events { __typename category name points createdAt } } }"#
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
          .field("events", [Event?].self),
        ] }

        var events: [Event?] { __data["events"] }

        /// GetUser.Event
        ///
        /// Parent Type: `Event`
        struct Event: SHPESchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Event }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("category", String.self),
            .field("name", String.self),
            .field("points", Int.self),
            .field("createdAt", String.self),
          ] }

          var category: String { __data["category"] }
          var name: String { __data["name"] }
          var points: Int { __data["points"] }
          var createdAt: String { __data["createdAt"] }
        }
      }
    }
  }

}