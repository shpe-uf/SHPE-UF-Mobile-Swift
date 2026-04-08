import SwiftUI
import Charts

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = StatisticsViewModel.shared
    @StateObject var appVM: AppViewModel = AppViewModel.appVM

    @State private var selectedTab = 0
    @State private var selectedSlice: (name: String, value: Int)? = nil
    @State private var plotFrame: CGRect? = nil
    
    let tabs = ["Major", "Year", "Country", "Gender", "Ethnicity"]

    var backgroundColor: Color {
        appVM.darkMode ? Color(.darkdarkBlue) : .white
    }

    var textColor: Color {
        appVM.darkMode ? .white : .black
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(appVM.darkMode ? "Back" : "lightmode_back")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, UIScreen.main.bounds.width * 0.10)
                        }

                        Text("Statistics")
                            .font(.custom("Viga-Regular", size: 28))
                            .foregroundColor(textColor)
                            .fontWeight(.bold)
                            .padding(.trailing, UIScreen.main.bounds.width * 0.20)
                    }
                    .padding(UIScreen.main.bounds.width * 0.05)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)

                    HStack {
                        ForEach(tabs.indices, id: \.self) { index in
                            Button {
                                selectedTab = index
                                selectedSlice = nil
                            } label: {
                                Text(tabs[index])
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(index == selectedTab ? .white : textColor)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        index == selectedTab
                                        ? RoundedRectangle(cornerRadius: 10).fill(Color.orange)
                                        : nil
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(backgroundColor)

                    ScrollView {
                        StatisticsChartView(
                            data: vm.statsFor(category: tabs[selectedTab]),
                            total: max(vm.total(for: tabs[selectedTab]), 1),
                            selectedSlice: $selectedSlice,
                            plotFrame: $plotFrame
                        )

                        StatisticsTableView(
                            table: vm.statsFor(category: tabs[selectedTab]),
                            total: vm.total(for: tabs[selectedTab])
                        )
                    }
                }
            }
            .onAppear { vm.loadAll() }
            .preferredColorScheme(appVM.darkMode ? .dark : .light)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    StatisticsView()
}
