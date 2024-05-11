import Foundation
import UIKit

@MainActor
final class ItemRowViewModel: ObservableObject {
    @Published var item: ItemRowModel

    var imageSource: String? {
        item.imageSource
    }

    var categoryText: String? {
        return item.year + (item.category.isEmpty ? "" : " • " + item.category)
    }

    var normalizedTitle: String? {
        item.normalizedTitle
    }

    var text: String? {
        item.text
    }

    init(item: ItemRowModel) {
        self.item = item
    }
}
