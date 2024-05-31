import Foundation
import SwiftData
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    @ObservedObject var appState = AppState()

    @Published var isLoading = false
    @Published var items: [ItemRowModel] = []
    @Published var error: Error?

    private let modelContext: ModelContext
    private let taskHandler = TaskHandler()
    private let itemRepository = ItemRepository()
    private let itemTransformer = ItemTransformer()

    var years: [Int] {
        items.map(\.id)
    }

    var dataIsFromToday: Bool {
        if let date = items.first?.date {
            return Calendar.autoupdatingCurrent.isDateInToday(date)
        }
        return true
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func onAppear() async {
//        await fetchCache()
//        if items.isEmpty || !dataIsFromToday {
        await fetch(in: appState.language)
//        }
    }

    func getItemID(with year: Int) -> Int? {
        items.first(where: { $0.id == year })?.id
    }

    func refreshData() {
        taskHandler.cancelTasks()
        taskHandler.handleActionOnMainThread { [weak self] in
            guard let self else {
                return
            }
            await fetch(manual: true, in: appState.language)
        }
    }

    private func fetch(manual _: Bool = false, in language: SupportedLanguage) async {
        taskHandler.handleActionDetached { [weak self] in
            guard let self else {
                return
            }
            isLoading = true
            defer { isLoading = false }
            do {
                if let receivedItem = try await itemRepository.getItem(in: language) {
                    let transformedItems = try await itemTransformer.getDomainModel(from: receivedItem)
                    self.items = transformedItems.sorted(by: { $0.id > $1.id })
                    try modelContext.delete(model: ItemRowModel.self)
                    for item in transformedItems {
                        modelContext.insert(item)
                    }
                }
            } catch {
                self.error = error
                print(String(describing: error))
            }
        }
    }

    private func fetchCache() async {
        taskHandler.handleActionOnMainThread { [weak self] in
            guard let self else {
                return
            }
            isLoading = true
            defer { isLoading = false }
            do {
                let descriptor = FetchDescriptor<ItemRowModel>(sortBy: [SortDescriptor(\.year)])
                items = try modelContext.fetch(descriptor)
            } catch {
                self.error = error
                print(String(describing: error))
            }
        }
    }
}
