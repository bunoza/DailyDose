import Foundation

final class ItemTransformer: Sendable {
    func getDomainModel(from item: Item?) async throws -> [ItemRowModel] {
        guard let providedItem = item,
              let selected = providedItem.selected
        else {
            throw DailyDoseError.transformerError
        }

        return try await withThrowingTaskGroup(of: ItemRowModel?.self) { group in
            for item in selected {
                group.addTask {
                    guard let pages = item.pages, !pages.isEmpty else {
                        throw DailyDoseError.transformerError
                    }

                    let normalizedTitle = pages.compactMap { $0.titles?.normalized }.first
                    let imageSource = pages.compactMap { $0.originalimage?.source }.first

                    return ItemRowModel(
                        year: String(item.year ?? 0),
                        normalizedTitle: normalizedTitle,
                        imageSource: imageSource,
                        text: item.text,
                        category: ItemTransformer.getCategory(for: item, from: providedItem)
                    )
                }
            }

            var domainModels = [ItemRowModel]()
            for try await model in group {
                if let model = model {
                    domainModels.append(model)
                }
            }

            return domainModels
        }
    }

    private static func getCategory(for selected: Selected, from item: Item) -> String {
        if item.births?.contains(where: { $0.text == selected.text }) == true {
            return "births"
        }
        if item.deaths?.contains(where: { $0.text == selected.text }) == true {
            return "deaths"
        }
        if item.holidays?.contains(where: { $0.text == selected.text }) == true {
            return "holidays"
        }
        if item.events?.contains(where: { $0.text == selected.text }) == true {
            return "events"
        }
        return ""
    }
}
