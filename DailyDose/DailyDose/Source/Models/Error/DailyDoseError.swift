import Foundation

enum DailyDoseError: Error {
    case networkError
    case persistenceError
    case genericError
    case transformerError
}
