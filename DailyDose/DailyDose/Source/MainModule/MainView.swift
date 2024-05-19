import SwiftData
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @State private var showSettingsSheet = false
    @State private var scrollIndex: Int = 0

    private var augmentation = 0.6

    init(
        modelContext: ModelContext
    ) {
        let viewModel = MainViewModel(modelContext: modelContext, language: .english)
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading")
                } else {
                    ScrollableVerticalList(items: viewModel.items, years: viewModel.years)
                }
            }
            .onChange(of: viewModel.language) { _, _ in
                showSettingsSheet = false
                viewModel.refreshData()
            }
            .sheet(isPresented: $showSettingsSheet) {
                Section {
                    Picker(selection: $viewModel.language) {
                        ForEach(SupportedLanguage.allCases, id: \.rawValue) { language in
                            Text(language.description)
                                .tag(language)
                        }
                    } label: {
                        Text("Source language:")
                    }
                    .pickerStyle(.automatic)
                }
                .presentationDetents([.medium])
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
