// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol SHPESchema_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == SHPESchema.SchemaMetadata {}

protocol SHPESchema_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == SHPESchema.SchemaMetadata {}

protocol SHPESchema_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == SHPESchema.SchemaMetadata {}

protocol SHPESchema_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == SHPESchema.SchemaMetadata {}

extension SHPESchema {
  typealias SelectionSet = SHPESchema_SelectionSet

  typealias InlineFragment = SHPESchema_InlineFragment

  typealias MutableSelectionSet = SHPESchema_MutableSelectionSet

  typealias MutableInlineFragment = SHPESchema_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    private static let objectTypeMap: [String: ApolloAPI.Object] = [
      "Event": SHPESchema.Objects.Event,
      "Mutation": SHPESchema.Objects.Mutation,
      "Partner": SHPESchema.Objects.Partner,
      "Query": SHPESchema.Objects.Query,
      "StatData": SHPESchema.Objects.StatData,
      "User": SHPESchema.Objects.User
    ]

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      objectTypeMap[typename]
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}