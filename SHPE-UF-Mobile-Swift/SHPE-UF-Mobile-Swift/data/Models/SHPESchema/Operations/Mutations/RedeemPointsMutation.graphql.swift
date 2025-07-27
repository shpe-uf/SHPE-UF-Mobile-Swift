// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class RedeemPointsMutation: GraphQLMutation {
    static let operationName: String = "RedeemPoints"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation RedeemPoints($redeemPointsInput: RedeemPointsInput) { redeemPoints(redeemPointsInput: $redeemPointsInput) { __typename fallPoints fallPercentile springPoints springPercentile summerPercentile summerPoints points events { __typename category name points createdAt id } } }"#
      ))

    public var redeemPointsInput: GraphQLNullable<RedeemPointsInput>

    public init(redeemPointsInput: GraphQLNullable<RedeemPointsInput>) {
      self.redeemPointsInput = redeemPointsInput
    }

    public var __variables: Variables? { ["redeemPointsInput": redeemPointsInput] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("redeemPoints", RedeemPoints.self, arguments: ["redeemPointsInput": .variable("redeemPointsInput")]),
      ] }

      var redeemPoints: RedeemPoints { __data["redeemPoints"] }

      /// RedeemPoints
      ///
      /// Parent Type: `User`
      struct RedeemPoints: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("fallPoints", Int.self),
          .field("fallPercentile", Int.self),
          .field("springPoints", Int.self),
          .field("springPercentile", Int.self),
          .field("summerPercentile", Int.self),
          .field("summerPoints", Int.self),
          .field("points", Int.self),
          .field("events", [Event?].self),
        ] }

        var fallPoints: Int { __data["fallPoints"] }
        var fallPercentile: Int { __data["fallPercentile"] }
        var springPoints: Int { __data["springPoints"] }
        var springPercentile: Int { __data["springPercentile"] }
        var summerPercentile: Int { __data["summerPercentile"] }
        var summerPoints: Int { __data["summerPoints"] }
        var points: Int { __data["points"] }
        var events: [Event?] { __data["events"] }

        /// RedeemPoints.Event
        ///
        /// Parent Type: `Event`
        struct Event: SHPESchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Event }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("category", String.self),
            .field("name", String.self),
            .field("points", Int.self),
            .field("createdAt", String.self),
            .field("id", SHPESchema.ID.self),
          ] }

          var category: String { __data["category"] }
          var name: String { __data["name"] }
          var points: Int { __data["points"] }
          var createdAt: String { __data["createdAt"] }
          var id: SHPESchema.ID { __data["id"] }
        }
      }
    }
  }

}