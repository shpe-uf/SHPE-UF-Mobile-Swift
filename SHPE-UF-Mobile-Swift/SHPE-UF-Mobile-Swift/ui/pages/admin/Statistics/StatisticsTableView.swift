import SwiftUI

struct StatisticsTableView: View {
    let table: [(name: String, value: Int)]
    let total: Int

    @Environment(\.colorScheme) var colorScheme

    var textColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var headerColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.15)
    }

    var rowColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.15) : Color.white
    }

    var borderColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.6) : Color.gray.opacity(0.4)
    }

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 0) {
                Text("Name")
                    .frame(width: 230, alignment: .leading)
                    .padding(8)
                    .background(headerColor)
                    .border(borderColor)
                    .foregroundColor(textColor)

                Text("Value")
                    .frame(width: 45, alignment: .trailing)
                    .padding(8)
                    .background(headerColor)
                    .border(borderColor)
                    .foregroundColor(textColor)

                Text("Percent")
                    .frame(width: 61, alignment: .trailing)
                    .padding(8)
                    .background(headerColor)
                    .border(borderColor)
                    .foregroundColor(textColor)
            }

            ForEach(table, id: \.name) { stat in
                let cleanName = stat.name
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                    .replacingOccurrences(of: "\u{200B}", with: "")

                let textWidth = cleanName.size(
                    withAttributes: [.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)]
                ).width

                let rowHeight: CGFloat = textWidth > 235 ? 42.5 : 20.3

                HStack(spacing: 0) {

                    Text(cleanName)
                        .frame(width: 230, alignment: .leading)
                        .padding(8)
                        .background(rowColor)
                        .border(borderColor)
                        .foregroundColor(textColor)

                    Text("\(stat.value)")
                        .frame(width: 45, height: rowHeight, alignment: .trailing)
                        .padding(8)
                        .background(rowColor)
                        .border(borderColor)
                        .foregroundColor(textColor)

                    Text(String(format: "%.2f%%", Double(stat.value) / Double(max(total, 1)) * 100))
                        .frame(width: 61, height: rowHeight, alignment: .trailing)
                        .padding(8)
                        .background(rowColor)
                        .border(borderColor)
                        .foregroundColor(textColor)
                }
            }
        }
        .padding()
    }
}
