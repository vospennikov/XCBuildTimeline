//
//  XcodeprojParser.swift
//  XCBuildTimeline
//
//  Created by Mikhail Vospennikov on 02.05.2023.
//

import Foundation
import XcodeProj

struct XcodeprojParser {
    var findSchemes: (URL) throws -> [String]
}

struct XcodeprojParserKey: InjectionKey {
    static var currentValue = XcodeprojParser(
        findSchemes: { projectPath in
            let xcodeproj = try XcodeProj(pathString: projectPath.path())
            let pbxproj = xcodeproj.pbxproj
            return pbxproj.nativeTargets.map { $0.name }
        }
    )
}
