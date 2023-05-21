//
//  Task.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 05.05.2023.
//

import Foundation

extension Task {
    @discardableResult static func delayed(
        seconds: TimeInterval,
        operation: @escaping @Sendable () async -> Void
    ) -> Self where Success == Void, Failure == Never {
        Self {
            do {
                try await Task<Never, Never>.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                await operation()
            } catch {}
        }
    }
}
