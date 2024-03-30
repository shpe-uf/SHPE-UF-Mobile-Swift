// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class EditUserProfileMutation: GraphQLMutation {
    static let operationName: String = "EditUserProfile"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation EditUserProfile($editUserProfileInput: EditUserProfileInput) { editUserProfile(editUserProfileInput: $editUserProfileInput) { __typename id } }"#
      ))

    public var editUserProfileInput: GraphQLNullable<EditUserProfileInput>

    public init(editUserProfileInput: GraphQLNullable<EditUserProfileInput>) {
      self.editUserProfileInput = editUserProfileInput
    }

    public var __variables: Variables? { ["editUserProfileInput": editUserProfileInput] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("editUserProfile", EditUserProfile.self, arguments: ["editUserProfileInput": .variable("editUserProfileInput")]),
      ] }

      var editUserProfile: EditUserProfile { __data["editUserProfile"] }

      /// EditUserProfile
      ///
      /// Parent Type: `User`
      struct EditUserProfile: SHPESchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { SHPESchema.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", SHPESchema.ID.self),
        ] }

        var id: SHPESchema.ID { __data["id"] }
      }
    }
  }

}