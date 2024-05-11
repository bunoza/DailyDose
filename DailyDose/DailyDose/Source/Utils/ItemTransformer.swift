import Foundation

actor ItemTransformer {
    func getDomainModel(from item: Item?) async throws -> [ItemRowModel] {
        guard let providedItem = item,
              let selected = providedItem.selected,
              !selected.isEmpty
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
                    let imageSource = pages.compactMap { $0.thumbnail?.source }.first

                    return ItemRowModel(
                        year: String(item.year ?? 0),
                        normalizedTitle: normalizedTitle,
                        imageSource: imageSource,
                        text: item.text,
                        category: ""
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
}
