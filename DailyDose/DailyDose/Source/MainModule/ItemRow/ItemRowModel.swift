import Foundation
import SwiftData

@Model
final class ItemRowModel: Sendable {
    let date: Date
    let year: String
    let normalizedTitle: String?
    let imageSource: String?
    let text: String?
    let category: String

    init(
        date: Date = Date(),
        year: String,
        normalizedTitle: String? = nil,
        imageSource: String? = nil,
        text: String? = nil,
        category: String
    ) {
        self.date = date
        self.year = year
        self.normalizedTitle = normalizedTitle
        self.imageSource = imageSource
        self.text = text
        self.category = category
    }
}
