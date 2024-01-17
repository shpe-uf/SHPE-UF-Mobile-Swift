// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class GetAlumnisQuery: GraphQLQuery {
    static let operationName: String = "GetAlumnisQuery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetAlumnisQuery { getAlumnis { __typename firstName lastName } }"#
      ))

    public init() {}

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getAlumnis", [GetAlumni?]?.self),
      ] }

      var getAlumnis: [GetAlumni?]? { __data["getAlumnis"] }

      /// GetAlumni
      ///
      /// Parent Type: `Alumni`
      struct GetAlumni: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Alumni }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("firstName", String.self),
          .field("lastName", String.self),
        ] }

        var firstName: String { __data["firstName"] }
        var lastName: String { __data["lastName"] }
      }
    }
  }

}