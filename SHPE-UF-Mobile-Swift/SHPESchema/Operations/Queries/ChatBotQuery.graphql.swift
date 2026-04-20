// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension SHPESchema {
  class ChatBotQuery: GraphQLQuery {
    static let operationName: String = "ChatBot"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ChatBot($question: String!, $persona: String) { chatBot(question: $question, persona: $persona) }"#
      ))

    public var question: String
    public var persona: GraphQLNullable<String>

    public init(
      question: String,
      persona: GraphQLNullable<String>
    ) {
      self.question = question
      self.persona = persona
    }

    public var __variables: Variables? { [
      "question": question,
      "persona": persona
    ] }

    struct Data: SHPESchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { SHPESchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("chatBot", String.self, arguments: [
          "question": .variable("question"),
          "persona": .variable("persona")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ChatBotQuery.Data.self
      ] }

      var chatBot: String { __data["chatBot"] }
    }
  }

}