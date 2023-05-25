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
    
    var logEntityParser: LogEntityParser {
        get { Self[LogEntityParserKey.self] }
        set { Self[LogEntityParserKey.self] = newValue }
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
    
    var timelineMapper: TimelineMapper {
        get { Self[TimelineMapperKey.self] }
        set { Self[TimelineMapperKey.self] = newValue }
    }
}
