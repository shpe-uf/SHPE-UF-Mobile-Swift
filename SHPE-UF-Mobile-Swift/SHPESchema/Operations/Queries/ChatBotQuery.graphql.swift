// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class ChatBotQuery: GraphQLQuery {
    static let operationName: String = "ChatBot"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ChatBot($question: String!) { chatBot(question: $question) }"#
      ))

    public var question: String

    public init(question: String) {
      self.question = question
    }

    public var __variables: Variables? { ["question": question] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("chatBot", String.self, arguments: ["question": .variable("question")]),
      ] }

      var chatBot: String { __data["chatBot"] }
    }
  }

}