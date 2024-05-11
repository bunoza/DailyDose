
import Foundation

public final class TaskHandler: @unchecked Sendable {
    typealias TaskItem = Task<Void, Never>
    private var taskStore = Set<TaskItem>()

    public init() {}

    deinit {
        cancelTasks()
    }

    public func cancelTasks() {
        taskStore.forEach { $0.cancel() }
        taskStore = []
    }

    public func handleActionOnMainThread(_ action: @escaping @MainActor @Sendable () async -> Void) {
        taskStore.insert(
            Task { await action() }
        )
    }

    public func handleActionDetached(_ action: @escaping @MainActor @Sendable () async -> Void) {
        taskStore.insert(
            Task.detached { await action() }
        )
    }

    public func handleAction(_ action: @escaping @Sendable () async -> Void) {
        taskStore.insert(
            Task { await action() }
        )
    }
}
