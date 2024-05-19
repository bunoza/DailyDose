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
                group.addTask { [weak self] in
                    guard let self, let pages = item.pages, !pages.isEmpty else {
                        throw DailyDoseError.transformerError
                    }

                    let normalizedTitle = pages.compactMap { $0.titles?.normalized }.first
                    let imageSource = pages.compactMap { $0.originalimage?.source }.first

                    return await ItemRowModel(
                        year: String(item.year ?? 0),
                        normalizedTitle: normalizedTitle,
                        imageSource: imageSource,
                        text: item.text,
                        category: getCategory(for: item, from: providedItem)
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

    private func getCategory(for selected: Selected, from item: Item) -> String {
        if let births = item.births,
           births.contains(where: { $0.text == selected.text })
        {
            return "births"
        }
        if let deaths = item.deaths,
           deaths.contains(where: { $0.text == selected.text })
        {
            return "deaths"
        }
        if let holidays = item.holidays,
           holidays.contains(where: { $0.text == selected.text })
        {
            return "holidays"
        }
        if let events = item.events,
           events.contains(where: { $0.text == selected.text })
        {
            return "events"
        }
        return ""
    }
}
