import Foundation

actor ItemRepository {
    func getItem(in language: SupportedLanguage = .english) async throws -> Item? {
        guard let url = URL(string: Constants.getURLString(in: language)) else {
            return nil
        }

        let request = URLRequest(url: url)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let item = try JSONDecoder().decode(Item.self, from: data)
            item.date = Date()
            return item
        } catch {
            throw error
        }
    }
}
