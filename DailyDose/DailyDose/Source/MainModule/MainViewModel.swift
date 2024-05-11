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

//    var yetToUpdate: Bool? {
//        if let date = items.first?.date {
//            return !Calendar.autoupdatingCurrent.isDateInToday(date)
//        }
//        return nil
//    }

    init(
        modelContext: ModelContext,
        language: SupportedLanguage = .english
    ) {
        self.modelContext = modelContext
        self.language = language
    }

    func onAppear() async {
        await fetchCache()
        if items.isEmpty {
            await fetch(in: language)
        }
    }

    func refreshData() {
        taskHandler.cancelTasks()
        taskHandler.handleAction { [weak self] in
            guard let self else {
                return
            }
            await fetch(manual: true, in: language)
        }
    }

    // TODO: yet to implement
//    private func shouldUpdate(manual: Bool) -> Bool {
//        if let yetToUpdate {
//            yetToUpdate || manual
//        } else {
//            manual
//        }
//    }

    private func fetch(manual _: Bool = false, in language: SupportedLanguage) async {
        taskHandler.handleActionDetached { [weak self] in
            guard let self else {
                return
            }

            do {
                if let receivedItem = try await itemRepository.getItem(in: language) {
                    let transformedItems = try await itemTransformer.getDomainModel(from: receivedItem)
                    self.items = transformedItems
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

            do {
                let descriptor = FetchDescriptor<ItemRowModel>(sortBy: [SortDescriptor(\.year)])
                items = try modelContext.fetch(descriptor)
            } catch {
                print(String(describing: error))
            }
        }
    }

    // TODO: fix this
//    func getCategory(for selected: Selected) -> String {
//        if let births = item.first?.births,
//           births.contains(where: { $0.text == selected.text }) {
//            return "births"
//        }
//        if let deaths = item.first?.deaths,
//           deaths.contains(where: { $0.text == selected.text }) {
//            return "deaths"
//        }
//        if let holidays = item.first?.holidays,
//           holidays.contains(where: { $0.text == selected.text }) {
//            return "holidays"
//        }
//        if let events = item.first?.events,
//           events.contains(where: { $0.text == selected.text }) {
//            return "events"
//        }
//        return ""
//    }
}
