import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme

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
                            Section {
                                ItemRowView(viewModel: ItemRowViewModel(item: item))
                                    .listRowInsets(EdgeInsets())
                                    .overlay {
                                        NavigationLink {
                                            ItemViewDetails(item: item)
                                        } label: {
                                            EmptyView()
                                        }
                                        .opacity(0)
                                    }
                            }
                        }
                    }
                    .onChange(of: viewModel.language) { _, _ in
                        viewModel.refreshData()
                    }
                    .refreshable {
                        viewModel.refreshData()
                    }
                }
            }
            .navigationTitle("On today's date")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.onAppear()
        }
    }
}
