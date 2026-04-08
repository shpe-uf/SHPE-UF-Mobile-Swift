import SwiftUI
import Charts

struct StatisticsChartView: View {
    let data: [(name: String, value: Int)]
    let total: Int
    @Binding var selectedSlice: (name: String, value: Int)?
    @Binding var plotFrame: CGRect?

    var body: some View {
        if data.isEmpty {
            ProgressView().tint(.white).padding()
        } else {
            ZStack {
                Chart(data, id: \.name) { item in
                    SectorMark(
                        angle: .value("Value", item.value),
                        outerRadius: .ratio(1.0)
                    )
                    .foregroundStyle(by: .value("Name", item.name))
                    .opacity(selectedSlice?.name == item.name ? 1 : 0.8)
                }
                .chartLegend(.hidden)
                .frame(height: 250)
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Color.clear
                            .contentShape(Rectangle())
                            .onAppear {
                                if let anchor = proxy.plotFrame {
                                    plotFrame = geo[anchor]
                                }
                            }
                            .onTapGesture { location in
                                guard let plotFrame = plotFrame else { return }

                                let chartCenter = CGPoint(x: plotFrame.midX, y: plotFrame.midY)
                                let dx = location.x - chartCenter.x
                                let dy = location.y - chartCenter.y
                                var angle = atan2(dy, dx)
                                angle += .pi/2
                                if angle < 0 { angle += 2 * .pi }

                                var cumulative: Double = 0
                                for item in data {
                                    let sliceAngle = Double(item.value) / Double(total) * 2 * .pi
                                    if angle >= cumulative && angle < cumulative + sliceAngle {
                                        selectedSlice = item
                                        return
                                    }
                                    cumulative += sliceAngle
                                }
                                selectedSlice = nil
                            }
                    }
                }

                if let selected = selectedSlice, let plotFrame = plotFrame {
                    let chartCenter = CGPoint(x: plotFrame.midX, y: plotFrame.midY)
                    
                    let angleMid: Double = {
                        var cumulative: Double = 0
                        for item in data {
                            let sliceAngle = Double(item.value) / Double(total) * 2 * .pi
                            if item.name == selected.name {
                                return cumulative + sliceAngle / 2
                            }
                            cumulative += sliceAngle
                        }
                        return 0
                    }()

                    let radius = plotFrame.width / 2 * 0.7
                    let x = chartCenter.x + CGFloat(cos(angleMid - .pi/2)) * (radius * 0.8)
                    let y = chartCenter.y + CGFloat(sin(angleMid - .pi/2)) * (radius * 0.8)

                    Text("\(selected.name): \(selected.value)")
                        .font(.caption)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .foregroundColor(.black)
                        .position(x: x, y: y)
                        .zIndex(1)
                }
            }
            .padding()
        }
    }
}
