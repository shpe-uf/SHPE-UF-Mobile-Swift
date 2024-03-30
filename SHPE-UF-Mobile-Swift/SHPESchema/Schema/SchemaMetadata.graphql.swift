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
  typealias ID = String

  typealias SelectionSet = SHPESchema_SelectionSet

  typealias InlineFragment = SHPESchema_InlineFragment

  typealias MutableSelectionSet = SHPESchema_MutableSelectionSet

  typealias MutableInlineFragment = SHPESchema_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Mutation": return SHPESchema.Objects.Mutation
      case "User": return SHPESchema.Objects.User
      case "Event": return SHPESchema.Objects.Event
      case "Query": return SHPESchema.Objects.Query
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}