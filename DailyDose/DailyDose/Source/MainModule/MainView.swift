import SwiftData
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @ObservedObject private var appState = AppState()

    @State private var showSettingsSheet = false
    @State private var scrollIndex: Int = 0

    private var augmentation = 0.6

    init(
        modelContext: ModelContext
    ) {
        let viewModel = MainViewModel(modelContext: modelContext)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading")
                } else if let _ = viewModel.error {
                    ErrorView {
                        viewModel.refreshData()
                        viewModel.error = nil
                    }
                } else {
                    ScrollableVerticalList(items: viewModel.items, years: viewModel.years)
                }
            }
            .onChange(of: appState.language) { _, _ in
                showSettingsSheet = false
                viewModel.refreshData()
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Settings", systemImage: "gear") {
                        showSettingsSheet = true
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh", systemImage: "arrow.clockwise") {
                        viewModel.refreshData()
                    }
                }
            }
            .navigationTitle("On today's date")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.onAppear()
        }
    }
}
