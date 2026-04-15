//
//  SettingsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 4/9/26.
//

import SwiftUI
import CoreData

struct SettingsView: View {

    @StateObject var vm: SettingsViewModel

    // @Environment, @EnvironmentObject, and @FetchRequest must live in the View —
    // they are SwiftUI-only property wrappers and cannot be placed in an ObservableObject class.
    @EnvironmentObject private var manager: DataManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @FetchRequest(sortDescriptors: []) private var userEvents: FetchedResults<CoreUserEvent>

    var body: some View {
        ZStack {
            vm.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Header
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(vm.foregroundColor)
                        .padding(.horizontal)
                        .padding(.top, 16)

                    

                    // MARK: Profile
                    SettingsSection(icon: "person", title: "Profile", foregroundColor: vm.foregroundColor) {

                        // MARK: Profile Header Card
                        vm.profileHeaderCard

                        SettingsNavRow(label: "Profile", foregroundColor: vm.foregroundColor) {
                            vm.showingProfile = true
                        }
                        if vm.profileVM.shpeito.permission.lowercased().contains("admin") {
                            Divider().background(vm.foregroundColor.opacity(0.15))
                            SettingsNavRow(label: "Admin Panel", foregroundColor: vm.foregroundColor) {
                                vm.showingAdminPanel = true
                            }
                        }
                    }

                    // MARK: Notifications
                    SettingsSection(icon: "bell", title: "Notifications", foregroundColor: vm.foregroundColor) {
                        SettingsToggleRow(
                            label: "Turn on All",
                            isOn: Binding(
                                get: { vm.allNotificationsSelected },
                                set: { vm.setAllNotifications($0, user: user, viewContext: viewContext) }
                            ),
                            foregroundColor: vm.foregroundColor
                        )
                        Divider().background(vm.foregroundColor.opacity(0.15))
                        SettingsToggleRow(
                            label: "GBM",
                            isOn: Binding(
                                get: { vm.notificationVM.isGBMSelected },
                                set: { vm.setNotification("GBM", $0, user: user, viewContext: viewContext) }
                            ),
                            foregroundColor: vm.foregroundColor
                        )
                        Divider().background(vm.foregroundColor.opacity(0.15))
                        SettingsToggleRow(
                            label: "Info Sessions",
                            isOn: Binding(
                                get: { vm.notificationVM.isInfoSelected },
                                set: { vm.setNotification("Info", $0, user: user, viewContext: viewContext) }
                            ),
                            foregroundColor: vm.foregroundColor
                        )
                        Divider().background(vm.foregroundColor.opacity(0.15))
                        SettingsToggleRow(
                            label: "Workshops",
                            isOn: Binding(
                                get: { vm.notificationVM.isWorkShopSelected },
                                set: { vm.setNotification("Workshop", $0, user: user, viewContext: viewContext) }
                            ),
                            foregroundColor: vm.foregroundColor
                        )
                        Divider().background(vm.foregroundColor.opacity(0.15))
                        SettingsToggleRow(
                            label: "Volunteering",
                            isOn: Binding(
                                get: { vm.notificationVM.isVolunteeringSelected },
                                set: { vm.setNotification("Volunteering", $0, user: user, viewContext: viewContext) }
                            ),
                            foregroundColor: vm.foregroundColor
                        )
                        Divider().background(vm.foregroundColor.opacity(0.15))
                        SettingsToggleRow(
                            label: "Socials",
                            isOn: Binding(
                                get: { vm.notificationVM.isSocialSelected },
                                set: { vm.setNotification("Social", $0, user: user, viewContext: viewContext) }
                            ),
                            foregroundColor: vm.foregroundColor
                        )
                    }

                    // MARK: Instagram Links
                    SettingsSection(icon: "camera", title: "Instagram Links", foregroundColor: vm.foregroundColor) {
                        ForEach(vm.instagramLinks, id: \.0) { item in
                            if item.0 != vm.instagramLinks.first?.0 {
                                Divider().background(vm.foregroundColor.opacity(0.15))
                            }
                            SettingsNavRow(label: item.0, foregroundColor: vm.foregroundColor) {
                                if let url = URL(string: item.1) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    }

                    // MARK: Sign Out
                    VStack(spacing: 0) {
                        SettingsNavRow(label: "Sign Out", foregroundColor: vm.foregroundColor) {
                            vm.signOut(user: user, coreEvents: coreEvents, userEvents: userEvents, viewContext: viewContext)
                        }
                    }
                    .background(vm.foregroundColor.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // MARK: Delete Account
                    VStack(spacing: 0) {
                        SettingsNavRow(label: "Delete Account", foregroundColor: .red) {
                            vm.clickedDeleteAccount = true
                        }
                    }
                    .background(Color.red.opacity(0.07))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
        }
        // Keep vm.colorScheme in sync so foregroundColor and background stay reactive
        .onAppear { vm.colorScheme = colorScheme }
        .onChange(of: colorScheme) { _, newValue in vm.colorScheme = newValue }
        .fullScreenCover(isPresented: $vm.showingProfile) {
            ProfileView(vm: vm.profileVM)
                .environmentObject(manager)
                .environment(\.managedObjectContext, viewContext)
        }
        .fullScreenCover(isPresented: $vm.showingAdminPanel) {
            AdminView()
        }
        .onAppear {
            vm.notificationVM.checkForPermission { permission in
                if !permission {
                    withAnimation(.easeIn) {
                        vm.attemptedToEnableNotifications = true
                    }
                }
            }
        }
        .alert("Delete Account", isPresented: $vm.clickedDeleteAccount) {
            Button("Delete", role: .destructive) {
                vm.deleteAccount(user: user, coreEvents: coreEvents, userEvents: userEvents, viewContext: viewContext)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove all your personal data. This action cannot be undone.")
        }
        .overlay(vm.notificationPermissionOverlay())
    }
}

// MARK: - Section Container

private struct SettingsSection<Content: View>: View {
    let icon: String
    let title: String
    let foregroundColor: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(foregroundColor)
                Text(title)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
            }
            .padding(.bottom, 12)

            VStack(spacing: 0) {
                content()
            }
            .background(foregroundColor.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Toggle Row

private struct SettingsToggleRow: View {
    let label: String
    @Binding var isOn: Bool
    let foregroundColor: Color

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(foregroundColor)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color("profile-orange"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Navigation Row

private struct SettingsNavRow: View {
    let label: String
    let foregroundColor: Color
    var textColor: Color? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .foregroundColor(textColor ?? foregroundColor)
                    .font(.body)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor((textColor ?? foregroundColor).opacity(0.5))
                    .font(.footnote)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    SettingsView(vm: SettingsViewModel(profileVM: ProfileViewModel(shpeito: SHPEito())))
}
