// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class SexStatQuery: GraphQLQuery {
    static let operationName: String = "SexStat"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query SexStat { getSexStat { __typename _id value } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getSexStat", [GetSexStat?]?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SexStatQuery.Data.self
      ] }

      var getSexStat: [GetSexStat?]? { __data["getSexStat"] }

      /// GetSexStat
      ///
      /// Parent Type: `StatData`
      struct GetSexStat: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.StatData }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("_id", String.self),
          .field("value", Int.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          SexStatQuery.Data.GetSexStat.self
        ] }

        var _id: String { __data["_id"] }
        var value: Int { __data["value"] }
      }
    }
  }

}