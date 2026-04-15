//
//  SettingsViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 4/11/26.
//

import Foundation
import SwiftUI
import CoreData

class SettingsViewModel: ObservableObject {

    // MARK: - Dependencies (injected via init)
    // manager and viewContext are SwiftUI environment values — they stay in the View,
    // not in the ViewModel. Functions that need them receive them as parameters.
    let profileVM: ProfileViewModel
    let notificationVM = NotificationViewModel.instance
    let appVM: AppViewModel = AppViewModel.appVM

    // MARK: - Published State
    @Published var colorScheme: ColorScheme = .light  // synced from View via onChange
    @Published var showingProfile = false
    @Published var showingAdminPanel = false
    @Published var clickedDeleteAccount = false
    @Published var attemptedToEnableNotifications = false

    // MARK: - Data
    let instagramLinks: [(String, String)] = [
        ("SHPE UF",     "https://www.instagram.com/shpeuf"),
        ("FYLP",        "https://www.instagram.com/fylp.shpeuf"),
        ("MentorSHPE",  "https://www.instagram.com/ufmentorshpe"),
        ("GradSHPE",    "https://www.instagram.com/gradshpeuf"),
        ("PKY SHPE",    "https://www.instagram.com/pky.shpe/"),
        ("Linktree",    "https://linktr.ee/shpeuf"),
    ]

    // MARK: - Computed Properties
    var allNotificationsSelected: Bool {
        notificationVM.isGBMSelected &&
        notificationVM.isInfoSelected &&
        notificationVM.isWorkShopSelected &&
        notificationVM.isVolunteeringSelected &&
        notificationVM.isSocialSelected
    }

    var foregroundColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var background: LinearGradient {
        colorScheme == .dark ? Constants.darkGradient : Constants.lightGradient
    }

    // MARK: - Init
    init(profileVM: ProfileViewModel) {
        self.profileVM = profileVM
    }

    // MARK: - Actions

    func signOut(
        user: FetchedResults<User>,
        coreEvents: FetchedResults<CalendarEvent>,
        userEvents: FetchedResults<CoreUserEvent>,
        viewContext: NSManagedObjectContext
    ) {
        guard !user.isEmpty else { return }
        NotificationViewModel.instance.clearPendingNotifications(fetchedEvents: coreEvents, viewContext: viewContext)
        CoreFunctions().clearCore(events: coreEvents, users: user, userEvents: userEvents, viewContext: viewContext)
        AppViewModel.appVM.setPageIndex(index: 3)
    }

    func deleteAccount(
        user: FetchedResults<User>,
        coreEvents: FetchedResults<CalendarEvent>,
        userEvents: FetchedResults<CoreUserEvent>,
        viewContext: NSManagedObjectContext
    ) {
        profileVM.deleteAccount { _ in
            CoreFunctions().clearCore(
                events: coreEvents,
                users: user,
                userEvents: userEvents,
                viewContext: viewContext
            )
            AppViewModel.appVM.setPageIndex(index: 3)
        }
    }

    func setNotification(_ eventType: String, _ enabled: Bool, user: FetchedResults<User>, viewContext: NSManagedObjectContext) {
        switch eventType {
        case "GBM":          notificationVM.isGBMSelected = enabled
        case "Info":         notificationVM.isInfoSelected = enabled
        case "Workshop":     notificationVM.isWorkShopSelected = enabled
        case "Volunteering": notificationVM.isVolunteeringSelected = enabled
        case "Social":       notificationVM.isSocialSelected = enabled
        default: break
        }
        CoreFunctions().editUserNotificationSettings(
            users: user,
            viewContext: viewContext,
            shpeito: AppViewModel.appVM.shpeito
        )
    }

    func setAllNotifications(_ enabled: Bool, user: FetchedResults<User>, viewContext: NSManagedObjectContext) {
        notificationVM.isGBMSelected = enabled
        notificationVM.isInfoSelected = enabled
        notificationVM.isWorkShopSelected = enabled
        notificationVM.isVolunteeringSelected = enabled
        notificationVM.isSocialSelected = enabled
        CoreFunctions().editUserNotificationSettings(
            users: user,
            viewContext: viewContext,
            shpeito: AppViewModel.appVM.shpeito
        )
    }

    // MARK: - Profile Header Card

    @ViewBuilder
    var profileHeaderCard: some View {
        HStack(spacing: 16) {
            Group {
                if let image = profileVM.shpeito.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(appVM.darkMode ? "DefaultPFPD" : "DefaultPFPL")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color("profile-orange"), lineWidth: 2))

            VStack(alignment: .leading, spacing: 4) {
                Text(profileVM.shpeito.name)
                    .font(.headline)
                    .foregroundColor(foregroundColor)
                Text("@\(profileVM.shpeito.username)")
                    .font(.subheadline)
                    .foregroundColor(foregroundColor.opacity(0.7))
            }

            Spacer()

            
        }
        .padding(16)
        .background(foregroundColor.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Overlays

    @ViewBuilder
    func notificationPermissionOverlay() -> some View {
        if attemptedToEnableNotifications {
            ZStack {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                    .zIndex(998)

                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Image("x_mark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    self.attemptedToEnableNotifications = false
                                }
                            }
                    }
                    Spacer()
                    Text("Trying to Stay Notified?")
                        .foregroundStyle(Color.white)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .padding(.bottom, 10)
                    Text("Please go to your device's \"Settings\" and enable notifications for SHPE UF")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .font(Font.custom("", size: 16))
                    Spacer()
                    Button {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings)
                        }
                    } label: {
                        Text("Go to Settings")
                            .foregroundStyle(Color.white)
                            .font(Font.custom("Viga-Regular", size: 24))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 30)
                            .background(Color.darkdarkBlue)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 20)
                }
                .zIndex(999)
                .padding()
                .frame(width: 309, height: 270, alignment: .center)
                .background(Color.profileOrange)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
            }
        }
    }

}
