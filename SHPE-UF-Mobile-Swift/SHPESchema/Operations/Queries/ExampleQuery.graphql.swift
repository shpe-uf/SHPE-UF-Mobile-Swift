// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class ExampleQuery: GraphQLQuery {
    static let operationName: String = "ExampleQuery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ExampleQuery { getUsers { __typename id } getEvents { __typename id } getEventsReversed { __typename id } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getUsers", [GetUser?]?.self),
        .field("getEvents", [GetEvent?]?.self),
        .field("getEventsReversed", [GetEventsReversed?]?.self),
      ] }

      var getUsers: [GetUser?]? { __data["getUsers"] }
      var getEvents: [GetEvent?]? { __data["getEvents"] }
      var getEventsReversed: [GetEventsReversed?]? { __data["getEventsReversed"] }

      /// GetUser
      ///
      /// Parent Type: `User`
      struct GetUser: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", SHPESchema.ID.self),
        ] }

        var id: SHPESchema.ID { __data["id"] }
      }

      /// GetEvent
      ///
      /// Parent Type: `Event`
      struct GetEvent: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", SHPESchema.ID.self),
        ] }

        var id: SHPESchema.ID { __data["id"] }
      }

      /// GetEventsReversed
      ///
      /// Parent Type: `Event`
      struct GetEventsReversed: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", SHPESchema.ID.self),
        ] }

        var id: SHPESchema.ID { __data["id"] }
      }
    }
  }

}