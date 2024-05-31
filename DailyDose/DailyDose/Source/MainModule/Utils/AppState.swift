
import SwiftUI

final class AppState: ObservableObject {
    static let shared = AppState()

    @AppStorage("supported_language") var language: SupportedLanguage = .english
}
