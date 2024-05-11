
import Foundation

enum Constants {
    static func getBaseURL(_ language: SupportedLanguage = .english) -> String {
        "https://api.wikimedia.org/feed/v1/wikipedia/\(language.rawValue)/onthisday/all/"
    }

    static func getURLString(in language: SupportedLanguage = .english) -> String {
        var dayDateFormatted: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: Date())
        }

        var monthDateFormatted: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: Date())
        }

        return getBaseURL(language) + "\(monthDateFormatted)/\(dayDateFormatted)"
    }
}
