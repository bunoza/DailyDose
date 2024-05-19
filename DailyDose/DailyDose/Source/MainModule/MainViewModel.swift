import Foundation
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var language: SupportedLanguage = .english
    @Published var items: [ItemRowModel] = []

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

    init(
        modelContext: ModelContext,
        language: SupportedLanguage = .english
    ) {
        self.modelContext = modelContext
        self.language = language
    }

    func onAppear() async {
//        await fetchCache()
//        if items.isEmpty || !dataIsFromToday {
        await fetch(in: language)
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
            await fetch(manual: true, in: language)
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
                print(String(describing: error))
            }
        }
    }
}
