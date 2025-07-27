// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class CreateEventMutation: GraphQLMutation {
    static let operationName: String = "CreateEvent"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateEvent($createEventInput: CreateEventInput) { createEvent(createEventInput: $createEventInput) { __typename category code expiration name points request } }"#
      ))

    public var createEventInput: GraphQLNullable<CreateEventInput>

    public init(createEventInput: GraphQLNullable<CreateEventInput>) {
      self.createEventInput = createEventInput
    }

    public var __variables: Variables? { ["createEventInput": createEventInput] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("createEvent", [CreateEvent?]?.self, arguments: ["createEventInput": .variable("createEventInput")]),
      ] }

      var createEvent: [CreateEvent?]? { __data["createEvent"] }

      /// CreateEvent
      ///
      /// Parent Type: `Event`
      struct CreateEvent: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Event }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("category", String.self),
          .field("code", String.self),
          .field("expiration", String.self),
          .field("name", String.self),
          .field("points", Int.self),
          .field("request", Bool.self),
        ] }

        var category: String { __data["category"] }
        var code: String { __data["code"] }
        var expiration: String { __data["expiration"] }
        var name: String { __data["name"] }
        var points: Int { __data["points"] }
        var request: Bool { __data["request"] }
      }
    }
  }

}