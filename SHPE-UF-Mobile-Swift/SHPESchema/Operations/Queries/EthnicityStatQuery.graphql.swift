// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class EthnicityStatQuery: GraphQLQuery {
    static let operationName: String = "EthnicityStat"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query EthnicityStat { getEthnicityStat { __typename _id value } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getEthnicityStat", [GetEthnicityStat?]?.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        EthnicityStatQuery.Data.self
      ] }

      var getEthnicityStat: [GetEthnicityStat?]? { __data["getEthnicityStat"] }

      /// GetEthnicityStat
      ///
      /// Parent Type: `StatData`
      struct GetEthnicityStat: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.StatData }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("_id", String.self),
          .field("value", Int.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          EthnicityStatQuery.Data.GetEthnicityStat.self
        ] }

        var _id: String { __data["_id"] }
        var value: Int { __data["value"] }
      }
    }
  }

}