// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class YearStatQuery: GraphQLQuery {
    static let operationName: String = "YearStat"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query YearStat { getYearStat { __typename _id value } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getYearStat", [GetYearStat?]?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        YearStatQuery.Data.self
      ] }

      var getYearStat: [GetYearStat?]? { __data["getYearStat"] }

      /// GetYearStat
      ///
      /// Parent Type: `StatData`
      struct GetYearStat: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.StatData }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("_id", String.self),
          .field("value", Int.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          YearStatQuery.Data.GetYearStat.self
        ] }

        var _id: String { __data["_id"] }
        var value: Int { __data["value"] }
      }
    }
  }

}