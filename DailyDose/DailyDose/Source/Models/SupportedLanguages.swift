import Foundation

enum SupportedLanguage: String, CaseIterable {
    case english = "en"
    case german = "de"
    case french = "fr"
    case swedish = "sv"
    case portuguese = "pt"
    case russian = "ru"
    case spanish = "es"
    case arabic = "ar"
    case bosnian = "bs"

    var description: String {
        switch self {
        case .english:
            "English"
        case .german:
            "German"
        case .french:
            "French"
        case .swedish:
            "Swedish"
        case .portuguese:
            "Portuguese"
        case .russian:
            "Russian"
        case .spanish:
            "Spanish"
        case .arabic:
            "Arabic"
        case .bosnian:
            "Bosnian"
        }
    }
}
