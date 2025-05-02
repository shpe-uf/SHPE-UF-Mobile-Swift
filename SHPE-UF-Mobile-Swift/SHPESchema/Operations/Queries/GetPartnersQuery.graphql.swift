// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class GetPartnersQuery: GraphQLQuery {
    static let operationName: String = "GetPartners"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetPartners { getPartners { __typename name photo tier } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getPartners", [GetPartner?]?.self),
      ] }

      var getPartners: [GetPartner?]? { __data["getPartners"] }

      /// GetPartner
      ///
      /// Parent Type: `Partner`
      struct GetPartner: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Partner }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("photo", String.self),
          .field("tier", String.self),
        ] }

        var name: String { __data["name"] }
        var photo: String { __data["photo"] }
        var tier: String { __data["tier"] }
      }
    }
  }

}