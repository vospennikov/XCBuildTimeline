//
//  FileFinder.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 28.04.2023.
//

import Foundation

struct FileFinder {
    var findFilesOfType: @Sendable (_ path: URL, _ pathExtension: String) async throws -> [URL]
}

struct FileFinderKey: InjectionKey {
    static var currentValue = FileFinder(
        findFilesOfType: { path, pathExtension in
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[URL], Error>) in
                let fileManager = FileManager.default
                
                if let enumerator = fileManager.enumerator(
                    at: path,
                    includingPropertiesForKeys: nil,
                    options: [.skipsHiddenFiles, .skipsPackageDescendants]
                ) {
                    var projects: [URL] = []
                    
                    for case let fileURL as URL in enumerator {
                        guard fileURL.pathExtension == pathExtension else {
                            continue
                        }
                        projects.append(fileURL)
                    }
                    continuation.resume(returning: projects)
                }
            }
        }
    )
}
