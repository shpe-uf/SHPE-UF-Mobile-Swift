// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class MajorStatQuery: GraphQLQuery {
    static let operationName: String = "MajorStat"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query MajorStat { getMajorStat { __typename _id value } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getMajorStat", [GetMajorStat?]?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MajorStatQuery.Data.self
      ] }

      var getMajorStat: [GetMajorStat?]? { __data["getMajorStat"] }

      /// GetMajorStat
      ///
      /// Parent Type: `StatData`
      struct GetMajorStat: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.StatData }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("_id", String.self),
          .field("value", Int.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MajorStatQuery.Data.GetMajorStat.self
        ] }

        var _id: String { __data["_id"] }
        var value: Int { __data["value"] }
      }
    }
  }

}