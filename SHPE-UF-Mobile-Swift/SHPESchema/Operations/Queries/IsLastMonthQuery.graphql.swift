// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class IsLastMonthQuery: GraphQLQuery {
    static let operationName: String = "IsLastMonth"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query IsLastMonth { lastMontOfYear }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("lastMontOfYear", Bool.self),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        IsLastMonthQuery.Data.self
      ] }

      var lastMontOfYear: Bool { __data["lastMontOfYear"] }
    }
  }

}