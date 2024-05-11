
import Foundation

actor ItemRepository {
    private func getURL(in language: SupportedLanguage = .english) async -> URL? {
        URL(string: Constants.getURLString(in: language))
    }

    func getItem(in language: SupportedLanguage = .english) async throws -> Item? {
        guard let url = await getURL(in: language) else {
            return nil
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let item = try JSONDecoder().decode(Item.self, from: data)
        item.date = Date()
        return item
    }
}
