import SwiftUI

struct HomeView: View {
    @State private var selectedTab: String = ""
    @StateObject private var artistVM = ArtistViewModel()
    @StateObject private var albumVM = AlbumViewModel()
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                TopBarView(selectedTab: $selectedTab, profileViewModel: profileVM, showNotification: showInAppNotification)
                    .frame(maxWidth: .infinity)
                    .environmentObject(appViewModel)
                contentView(for: selectedTab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(.ultraThinMaterial)
            .environmentObject(notificationManager)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            appViewModel.profileViewModel = profileVM
            profileVM.fetchUserProfile()
        }
    }
    
    func showInAppNotification(_ message: String) {
        let inAppEnabled = UserDefaults.standard.bool(forKey: "inAppNotificationsEnabled")
        guard inAppEnabled else { return }
        notificationManager.show(message: message)
    }

    @ViewBuilder
    private func contentView(for tab: String) -> some View {
        switch tab {
        case "":
            ScrollView {
                VStack(spacing: 24) {
                    TrackCarouselView()
                    AlbumCarouselView()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        case "Artisti":
            ArtistView(viewModel: artistVM)
        case "Album":
            AlbumView(viewModel: albumVM)
        case "Classifiche":
            ClassificationView()
        default:
            ScrollView {
                VStack(spacing: 24) {
                    TrackCarouselView()
                    AlbumCarouselView()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
    }
}
#Preview {
    HomeView()
}
