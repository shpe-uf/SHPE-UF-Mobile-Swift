import SwiftUI

struct GuestCalendarView: View {
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    
    var body: some View {
        VStack {
            // 🔹 Header Section
            HStack {
                Text("January")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    appVM.setPageIndex(index: 0) // Go back to sign-in
                }) {
                    HStack {
                        Text("Login")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right.to.line")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color(red: 0.82, green: 0.35, blue: 0.09))
            
            // 🔹 Events List Section
            ScrollView {
                VStack(spacing: 10) {
                    
                }
                .background(Color("darkBlue")) // Background color matching home page
                
                Spacer()
                
                // 🔹 Bottom Navigation Bar (Matching Home Page)
                HStack {
                    Button(action: {
                        appVM.setPageIndex(index: 4) // Guest Info
                    }) {
                        Image(systemName: "person.3.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        appVM.setPageIndex(index: 5) // Refresh or stay on calendar
                    }) {
                        Image(systemName: "icon_calendar")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        appVM.setPageIndex(index: 6) // Go to Partners Page
                    }) {
                        Image(systemName: "handshake")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(red: 0.82, green: 0.35, blue: 0.09)) // Matching top bar color
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    // 🔹 Event Card Component (Reused from Home Page)
    struct EventCard: View {
        var title: String
        var date: String
        var time: String
        var color: Color
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                        Text(date)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(color)
            .cornerRadius(10)
        }
    }
}
#Preview {
    GuestCalendarView()
}
