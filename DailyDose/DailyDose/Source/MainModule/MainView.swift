
import SwiftData
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel

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
                    List {
                        Section {
                            Picker(selection: $viewModel.language) {
                                ForEach(SupportedLanguage.allCases, id: \.rawValue) { language in
                                    Text(language.description)
                                        .tag(language)
                                }
                            } label: {
                                Text("Source language:")
                            }
                        }

                        ForEach(viewModel.items) { item in
                            NavigationLink {
                                ItemViewDetails(item: item)
                            } label: {
                                ItemRowView(viewModel: ItemRowViewModel(item: item))
                            }
                        }
                    }
                    .onChange(of: viewModel.language) { _, _ in
                        viewModel.isLoading = true
                        viewModel.refreshData()
                        viewModel.isLoading = false
                    }
                    .refreshable {
                        viewModel.isLoading = true
                        viewModel.refreshData()
                        viewModel.isLoading = false
                    }
                }
            }
            .navigationTitle("On today's date")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            viewModel.isLoading = true
            await viewModel.onAppear()
            viewModel.isLoading = false
        }
    }
}
