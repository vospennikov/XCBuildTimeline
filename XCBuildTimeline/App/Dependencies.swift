//
//  Dependencies.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 20.05.2023.
//

import Foundation
import Shell

extension InjectedValues {
    var fileFinder: FileFinder {
        get { Self[FileFinderKey.self] }
        set { Self[FileFinderKey.self] = newValue }
    }
    
    var timelineParser: TimelineParser {
        get { Self[TimelineParserKey.self] }
        set { Self[TimelineParserKey.self] = newValue }
    }
    
    var shellExecutor: Shell {
        get { Self[ShellExecutorKey.self] }
        set { Self[ShellExecutorKey.self] = newValue }
    }
    
    var xcodeprojParser: XcodeprojParser {
        get { Self[XcodeprojParserKey.self] }
        set { Self[XcodeprojParserKey.self] = newValue }
    }
    
    var timlineScriptInstaller: TimlineScriptInstaller {
        get { Self[TimlineScriptInstallerKey.self] }
        set { Self[TimlineScriptInstallerKey.self] = newValue }
    }
}
