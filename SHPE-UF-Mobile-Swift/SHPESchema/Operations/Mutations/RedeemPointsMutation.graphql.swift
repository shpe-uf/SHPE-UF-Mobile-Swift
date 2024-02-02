// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class RedeemPointsMutation: GraphQLMutation {
    static let operationName: String = "RedeemPoints"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation RedeemPoints($redeemPointsInput: RedeemPointsInput) { redeemPoints(redeemPointsInput: $redeemPointsInput) { __typename fallPoints springPoints summerPoints } }"#
      ))

    public var redeemPointsInput: GraphQLNullable<RedeemPointsInput>

    public init(redeemPointsInput: GraphQLNullable<RedeemPointsInput>) {
      self.redeemPointsInput = redeemPointsInput
    }

    public var __variables: Variables? { ["redeemPointsInput": redeemPointsInput] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
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

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.User }
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
